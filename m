From: Pablo Neira <pablo@eurodev.net>
Subject: Re: locking issue in ip_conntrack_alter_reply
Date: Mon, 03 May 2004 15:26:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40964868.4040904@eurodev.net>
References: <Pine.LNX.4.44.0405031523560.15193-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060804040407070608050603"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
 Patrick McHardy <kaber@trash.net>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0405031523560.15193-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060804040407070608050603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Henrik Nordstrom wrote:

>>Attached the patch to fix this.
>>    
>>
>
>Isn't there a LOCK/UNLOCK imbalance in your patch?
>  
>

you are right, I should rush... :-( Sorry!

regards,
Pablo


--------------060804040407070608050603
Content-Type: text/plain;
 name="alter_reply_locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="alter_reply_locking.patch"

Index: net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
RCS file: /home/cvs/linux-2.6/net/ipv4/netfilter/ip_conntrack_core.c,v
retrieving revision 1.1.1.1
diff -u -r1.1.1.1 ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2 May 2004 13:26:10 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	3 May 2004 13:23:43 -0000
@@ -1093,9 +1093,9 @@
 int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			     const struct ip_conntrack_tuple *newreply)
 {
-	WRITE_LOCK(&ip_conntrack_lock);
+	READ_LOCK(&ip_conntrack_lock);
 	if (__ip_conntrack_find(newreply, conntrack)) {
-		WRITE_UNLOCK(&ip_conntrack_lock);
+		READ_UNLOCK(&ip_conntrack_lock);
 		return 0;
 	}
 	/* Should be unconfirmed, so not in hash table yet */
@@ -1109,7 +1109,7 @@
 		conntrack->helper = LIST_FIND(&helpers, helper_cmp,
 					      struct ip_conntrack_helper *,
 					      newreply);
-	WRITE_UNLOCK(&ip_conntrack_lock);
+	READ_UNLOCK(&ip_conntrack_lock);
 
 	return 1;
 }

--------------060804040407070608050603--
