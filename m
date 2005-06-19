From: Pablo Neira <pablo@eurodev.net>
Subject: Re: FIX: connlimit NULL pointer kernel panic
Date: Sun, 19 Jun 2005 14:12:37 +0200
Message-ID: <42B56135.2010703@eurodev.net>
References: <20050519075405.7DF8640023@socios.momona.org>
	<428C78CE.2040904@eurodev.net> <42AAFD32.1000608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020103070909010805000004"
Cc: mateusz@republika.pl, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AAFD32.1000608@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020103070909010805000004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>Forte Systems - Iosif Peterfi wrote:
>>
>>
>>>Here is a diff -urN patch for what has been discussed except the
>>>conntrack
>>>event-api. Works fine on 2.6.1-gentoo-r8, patch-o-matic-ng-20050516. 
>>
>>
>>Hm, didn't I also tell you that you have to sed
>>'s/spin_unlock/spin_unlock_bh'?
>>
>>well, it doesn't matter, attached the correct patch that applies cleanly
>>to pom-ng.
> 
> 
> Thanks Pablo, I've applied the patch. Can you send patches for the 2.4
> and the old 2.6 version too?

Attached.

--
Pablo

--------------020103070909010805000004
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: linux/net/ipv4/netfilter/ipt_connlimit.c
===================================================================
--- linux/net/ipv4/netfilter/ipt_connlimit.c	(revision 3889)
+++ linux/net/ipv4/netfilter/ipt_connlimit.c	(working copy)
@@ -55,7 +55,7 @@
 	struct ipt_connlimit_conn *conn;
 	struct list_head *hash,*lh;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	tuple = ct->tuplehash[0].tuple;
 	hash = &data->iphash[ipt_iphash(addr & mask)];
 
@@ -63,8 +63,8 @@
 	for (lh = hash->next; lh != hash; lh = lh->next) {
 		conn = list_entry(lh,struct ipt_connlimit_conn,list);
 		found = ip_conntrack_find_get(&conn->tuple,ct);
-		if (0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
-		    found != NULL &&
+		if (found != NULL &&
+		    0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
 		    found->ctrack->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
 			/* Just to be sure we have it only once in the list.
 			   We should'nt see tuples twice unless someone hooks this
@@ -117,7 +117,7 @@
 		list_add(&conn->list,hash);
 		matches++;
 	}
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 	return matches;
 }
 
Index: linux-2.6/net/ipv4/netfilter/ipt_connlimit.c
===================================================================
--- linux-2.6/net/ipv4/netfilter/ipt_connlimit.c	(revision 3889)
+++ linux-2.6/net/ipv4/netfilter/ipt_connlimit.c	(working copy)
@@ -55,7 +55,7 @@
 	struct ipt_connlimit_conn *conn;
 	struct list_head *hash,*lh;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	tuple = ct->tuplehash[0].tuple;
 	hash = &data->iphash[ipt_iphash(addr & mask)];
 
@@ -63,9 +63,9 @@
 	for (lh = hash->next; lh != hash; lh = lh->next) {
 		conn = list_entry(lh,struct ipt_connlimit_conn,list);
 		found = ip_conntrack_find_get(&conn->tuple,ct);
-		if (0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
-		    found != NULL &&
-		    found->ctrack->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
+		if (found != NULL
+		    && 0 == memcmp(&conn->tuple,&tuple,sizeof(tuple))
+		    && found->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
 			/* Just to be sure we have it only once in the list.
 			   We should'nt see tuples twice unless someone hooks this
 			   into a table without "-p tcp --syn" */
@@ -110,7 +110,7 @@
 #endif
 		conn = kmalloc(sizeof(*conn),GFP_ATOMIC);
 		if (NULL == conn) {
-			spin_unlock(&data->lock);
+			spin_unlock_bh(&data->lock);
 			return -1;
 		}
 		memset(conn,0,sizeof(*conn));
@@ -119,7 +119,7 @@
 		list_add(&conn->list,hash);
 		matches++;
 	}
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 	return matches;
 }
 

--------------020103070909010805000004--
