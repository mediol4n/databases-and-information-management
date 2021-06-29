package bazy.lab.l3.zadania;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.Set;

import org.bson.Document;

import com.mongodb.*;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.model.Projections;
 /* 
  * Tworzenie bazy w shellu : use MDBMusic
  * Tworzenie kolekcji:
  * 	MDBMusic.createCollection('album')
  * 	MDBMusic.createCollection('zespol')
  * 	MDBMusic.createCollection('utwor')
  * 	Import z csv z bazy danych music.
  */

public class Mongo {

	public static MongoClient mongoClient;
	public static DB database;
	public static void main(String[] args){
		 try {
			mongoClient = new MongoClient();
			database = mongoClient.getDB("MDBMusic");
			DBCollection zespol = database.getCollection("zespol");
			DBCollection album = database.getCollection("album");
			DBCollection utwor = database.getCollection("utwor");
			

			
			//ZADANIE 10
			
			
		   /*	
			DBObject doc1 = new BasicDBObject("id", 199).append("nazwa", "Wu-Tang Clan").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "California").append("miasto", "Los Angeles"));
			zespol.insert(doc1);
			DBObject doc2 = new BasicDBObject("id", 200).append("nazwa", "N.W.A").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "California").append("miasto", "Compton"));
			zespol.insert(doc2);
			DBObject doc3 = new BasicDBObject("id", 201).append("nazwa", "Cypress Hill").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "California").append("miasto", "Los Angeles"));
			zespol.insert(doc3);
			DBObject doc4 = new BasicDBObject("id", 202).append("nazwa", "A Tribe Called Quest").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Nowy Jork").append("miasto", "Nowy Jork"));
			zespol.insert(doc4);
			DBObject doc5 = new BasicDBObject("id", 203).append("nazwa", "Outkast").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Georgia").append("miasto", "Atlanta"));
			zespol.insert(doc5);
			DBObject doc6 = new BasicDBObject("id", 204).append("nazwa", "Three 6 Mafia").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Tennessee").append("miasto", "Memphis"));
			zespol.insert(doc6);
			DBObject doc7 = new BasicDBObject("id", 205).append("nazwa", "Public Enemy").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Nowy Jork").append("miasto", "Nowy Jork"));
			zespol.insert(doc7);
			DBObject doc8 = new BasicDBObject("id", 206).append("nazwa", "Run-D.M.C.").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Nowy Jork").append("miasto", "Nowy Jork"));
			zespol.insert(doc8);
			DBObject doc9 = new BasicDBObject("id", 207).append("nazwa", "Beastie Boys").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Nowy Jork").append("miasto", "Nowy Jork"));
			zespol.insert(doc9);
			DBObject doc10 = new BasicDBObject("id", 208).append("nazwa", "De La Soul").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "USA").append("stan", "Nowy Jork").append("miasto", "Long Island"));
			zespol.insert(doc10);
			 DBCursor cursor = zespol.find();
			while (cursor.hasNext()) {
			   DBObject obj = cursor.next();
			   System.out.println(obj);
			} */
			
			
			//ZADANIE 11
			/*DBObject doc1 = new BasicDBObject("tytul", "Southernplayalisticadillacmuzik").append("gatunek", "Hip Hop").append("zespol", 203);
			album.insert(doc1);
			DBObject doc2 = new BasicDBObject("tytul", "Speakerboxxx/The Love Below").append("gatunek", "Hip Hop").append("zespol", 203);
			album.insert(doc2);
			DBObject doc3 = new BasicDBObject("tytul", "Revolverlution").append("gatunek", "Hip Hop").append("zespol", 205);
			album.insert(doc3);
			DBObject doc4 = new BasicDBObject("tytul", "New Whirl Odor").append("gatunek", "Hip Hop").append("zespol", 205);
			album.insert(doc4);
			DBObject doc5 = new BasicDBObject("tytul", "King of Rock").append("gatunek", new Document("gatunek1", "Rapcore").append("gatunek2", "Hip Hop")).append("zespol", 206);
			album.insert(doc5);
			DBObject doc6 = new BasicDBObject("tytul", "Raising Hell").append("gatunek", "Hip Hop").append("zespol", 206);
			album.insert(doc6);
			DBObject doc7 = new BasicDBObject("tytul", "Hello Nasty").append("gatunek", "Rapcore").append("zespol", 207);
			album.insert(doc7);
			DBObject doc8 = new BasicDBObject("tytul", "Check Your Head").append("gatunek", "Rapcore").append("zespol", 207);
			album.insert(doc8);
			DBObject doc9 = new BasicDBObject("tytul", "3 Feet High and Rising").append("gatunek", "Jazz Hop").append("zespol", 208);
			album.insert(doc9);
			DBObject doc10 = new BasicDBObject("tytul", "Days Off EP").append("gatunek", "Hip Hop").append("zespol", 208);
			album.insert(doc10);
			DBObject doc11 = new BasicDBObject("tytul", "Wu-Tang Forever").append("gatunek", "Hardcore Rap").append("zespol", 199);
			album.insert(doc11);
			DBObject doc12 = new BasicDBObject("tytul", "Iron Flag").append("gatunek", "Hardcore Rap").append("zespol", 199);
			album.insert(doc12);
			DBObject doc13 = new BasicDBObject("tytul", "The Love Movement").append("gatunek", "Hip Hop").append("zespol", 202);
			album.insert(doc13);
			DBObject doc14 = new BasicDBObject("tytul", "Beats, Rhymes and Life").append("gatunek", "Hip Hop").append("zespol", 202);
			album.insert(doc14);
			DBObject doc15 = new BasicDBObject("tytul", "Straight Outta Compton").append("gatunek", "Gangsta Rap").append("zespol", 200);
			album.insert(doc15);
			DBObject doc16 = new BasicDBObject("tytul", "Niggaz4Life").append("gatunek", "Gangsta Rap").append("zespol", 200);
			album.insert(doc16);
			DBObject doc17 = new BasicDBObject("tytul", "Cypress Hill").append("gatunek", "Hip Hop").append("zespol", 201);
			album.insert(doc17);
			DBObject doc18 = new BasicDBObject("tytul", "Skul & Bones").append("gatunek", "Hip Hop").append("zespol", 201);
			album.insert(doc18);
			DBObject doc19 = new BasicDBObject("tytul", "Mystic Stylez").append("gatunek", "Gangsta Rap").append("zespol", 204);
			album.insert(doc19);
			DBObject doc20 = new BasicDBObject("tytul", "Last 2 Walk").append("gatunek", "Hip Hop").append("zespol", 204);
			album.insert(doc20);
			DBCursor cursor = album.find();
			while (cursor.hasNext()) {
			   DBObject obj = cursor.next();
			   System.out.println(obj);
			}
			*/
			
			//ZADANIE 12
			/*for (int i = 1; i <= 20; i++) {
				Random rn = new Random();
				int n = 600 - 100 + 1;
				int diff = rn.nextInt() % n;
				int randomNum =  100 + diff;
				randomNum = Math.abs(randomNum);
				DBObject doc = new BasicDBObject("id", 3288+i).append("tytul", "tytul" + i).append("czas", randomNum).append("album", "Southernplayalisticadillacmuzik").append("zespol", 203);
				utwor.insert(doc);
			}
			
			for(int i = 1; i <= 20; i++) {
				Random rn = new Random();
				int n = 600 - 100 + 1;
				int diff = rn.nextInt() % n;
				int randomNum =  100 + diff;
				randomNum = Math.abs(randomNum);
				int songNum = 20 + i;
				DBObject doc = new BasicDBObject("id", 3308+songNum).append("tytul", "tytul" + i).append("czas", randomNum).append("album", "Speakerboxxx/The Love Below").append("zespol", 203);
				utwor.insert(doc);
			}
			
			for(int i = 1; i <= 20; i++) {
				Random rn = new Random();
				int n = 600 - 100 + 1;
				int diff = rn.nextInt() % n;
				int randomNum =  100 + diff;
				randomNum = Math.abs(randomNum);
				int songNum = 40 + i;
				DBObject doc = new BasicDBObject("id", 3308+songNum).append("tytul", "tytul" + i).append("czas", randomNum).append("album", "Revolverlution").append("zespol", 205);
				utwor.insert(doc);
			}
			
			for(int i = 1; i <= 20; i++) {
				Random rn = new Random();
				int n = 600 - 100 + 1;
				int diff = rn.nextInt() % n;
				int randomNum =  100 + diff;
				randomNum = Math.abs(randomNum);
				int songNum = 60 + i;
				DBObject doc = new BasicDBObject("id", 3308+songNum).append("tytul", "tytul" + i).append("czas", randomNum).append("album", "New Whirl Odor").append("zespol", 205);
				utwor.insert(doc);
			}
			
			for(int i = 1; i <= 20; i++) {
				Random rn = new Random();
				int n = 600 - 100 + 1;
				int diff = rn.nextInt() % n;
				int randomNum =  100 + diff;
				randomNum = Math.abs(randomNum);
				int songNum = 80 + i;
				DBObject doc = new BasicDBObject("id", 3308+songNum).append("tytul", "tytul" + i).append("czas", randomNum).append("album", "Wu-Tang Forever").append("zespol", 199);
				utwor.insert(doc);
			} 

			DBCursor cursor = utwor.find();
			while (cursor.hasNext()) {
			   DBObject obj = cursor.next();
			   System.out.println(obj);
			} */
			
			//ZADANIE 13
			/*List<String> databases = mongoClient.getDatabaseNames();
			for(String dbName: databases) {
			        System.out.println("Database: " + dbName);
			        DB db  = mongoClient.getDB(dbName);

			        Set<String> collections = db.getCollectionNames();

			        for(String colName : collections) {
			            System.out.println("\t + Collection: "+colName);
			        }
			 }*/
			
			//ZADANIE 14
			int zespolNum = zespol.find().count();
			/*for (int i = 1; i <= zespolNum; i++) { 
			    BasicDBObject whereQuery = new BasicDBObject();
			    whereQuery.put("zespol", i);
			    int albums = album.find(whereQuery).count();
			    BasicDBObject prev = new BasicDBObject();
			    prev.put("id", i);
			    BasicDBObject curr = new BasicDBObject();
			    curr.append("$set", new BasicDBObject().append("liczbaAlbumow", albums));
				zespol.update(prev, curr);
			}
			
			DBCursor cursor = zespol.find();
			while (cursor.hasNext()) {
			   DBObject obj = cursor.next();
			   System.out.println(obj);
			}*/

			//ZADANIE 16
		    /*BasicDBObject neQuery = new BasicDBObject();
		    neQuery.put("liczbaAlbumow", new BasicDBObject("$gt", 3));
		    DBCursor cursor = zespol.find(neQuery);
		    while(cursor.hasNext()) {
		        System.out.println(cursor.next());
		    }*/
			
			//ZADANIE 17
			/*int max = 0;
			for (int i = 1; i <= zespolNum; i++) { 
			    BasicDBObject whereQuery = new BasicDBObject();
			    whereQuery.put("zespol", i);
			    int albums = album.find(whereQuery).count();
			    if (max < albums) {
			    	max = albums;
			    }
			}
			
			int numofBands = 0;
			for (int i = 0; i < max; i++) {
				BasicDBObject whereQuery = new BasicDBObject();
			    whereQuery.put("liczbaAlbumow", i);
			    numofBands = zespol.find(whereQuery).count();
			    if (numofBands > 3) {
			    	System.out.println(i);
			    	break;
			    }
			}*/
			
			//ZADANIE 18
			/*DBObject whereQuery = new BasicDBObject();
			whereQuery.put("gatunek", new Document("gatunek1", "Rock").append("gatunek2", "Metal"));
			DBCursor cursor = album.find(whereQuery);
			while(cursor.hasNext()) {
				System.out.println(cursor.next());
			}*/
			
			//ZADANIE 19
			/*DBObject doc11 = new BasicDBObject("id", 209).append("nazwa", "Macedonski zespol").append("liczbaAlbumow", 0)
					.append("miejsceZalozenia", new Document("kraj", "Macedonia"));
			zespol.insert(doc11); 
		    BasicDBObject newDocument = new BasicDBObject();
		    newDocument.append("$set", new BasicDBObject().append("miejsceZalozenia", new Document("kraj", "Macedonia Polnocna")));
		            
		    BasicDBObject searchQuery = new BasicDBObject("miejsceZalozenia", new Document("kraj", "Macedonia"));

		    zespol.update(searchQuery, newDocument);
			DBCursor cursor = zespol.find();
			while (cursor.hasNext()) {
			   DBObject obj = cursor.next();
			   System.out.println(obj);
			}*/
			
			//ZADANIE 20
			
			
		} catch (UnknownHostException e) {
			System.out.println("sory dolores");
		}


		
	}
}
