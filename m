From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Delete nfcache use in ip_table
Date: Thu, 05 May 2005 18:15:25 +0200
Message-ID: <427A469D.8030305@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040809040706050506010409"
Cc: Patrick McHardy <kaber@trash.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------040809040706050506010409
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Since we've removed the use of nfcache in iptables, I think that it 
should be remove in ip_tables.c as well because:

a) there's no utility on it
b) it can be source of interferences for the conntrack-event-api, and 
thus for conntrack_netlink and ct_sync.

Please see the email labeled as:
[Re: BUG/CONFLICT conntrack with preroute/postroute mangle table]

I could keep this as a seperate patch in conntrack-event-api pom-ng, but 
I prefer kill it now and forget about it. If you've got no reason to 
object, please then pass it to davem.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--
Pablo

--------------040809040706050506010409
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

Index: net/ipv4/netfilter/ip_tables.c
===================================================================
--- 6d7098bc350768f59a41090ca248ae430cd95b25/net/ipv4/netfilter/ip_tables.c  (mode:100644 sha1:8a54f92b8496a4218a243c35ab2b55ec659e7d18)
+++ uncommitted/net/ipv4/netfilter/ip_tables.c  (mode:100644)
@@ -313,7 +313,6 @@
 	do {
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
-		(*pskb)->nfcache |= e->nfcache;
 		if (ip_packet_match(ip, indev, outdev, &e->ip, offset)) {
 			struct ipt_entry_target *t;
 

--------------040809040706050506010409--
