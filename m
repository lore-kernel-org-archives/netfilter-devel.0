From: Pablo Neira <pablo@eurodev.net>
Subject: Re: locking issue in ip_conntrack_alter_reply
Date: Mon, 03 May 2004 15:05:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40964395.7010403@eurodev.net>
References: <Pine.LNX.4.33.0405031057120.24224-100000@blackhole.kfki.hu> <409637DB.6030600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070102030109090903070809"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <409637DB.6030600@trash.net>
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
--------------070102030109090903070809
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>
>> The assertion is right, because we alter unconfirmed packets when 
>> setting
>> up nat info. And you're also right, write-locking is unnecessary: the
>> entry is not in the hash table yet, so nobody else can grab and 
>> modify the
>> conntrack entry. [And it is overlooked in the per bucket locking 
>> patch too.]
>
>
> I've ported your conntrack patches to 2.6, I will include this change
> before adding them to CVS.


Attached the patch to fix this.

regards,
Pablo

--------------070102030109090903070809
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
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	3 May 2004 12:59:22 -0000
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
@@ -1109,7 +1109,6 @@
 		conntrack->helper = LIST_FIND(&helpers, helper_cmp,
 					      struct ip_conntrack_helper *,
 					      newreply);
-	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	return 1;
 }

--------------070102030109090903070809--
