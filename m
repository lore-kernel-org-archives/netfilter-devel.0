From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: Fix invalid return values from sctp_new
Date: Mon, 20 Sep 2004 10:28:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414E9493.3020800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090800020606020804060209"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kiran Kumar <immidi_kiran@yahoo.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090800020606020804060209
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kiran,

there are multiple places in sctp_new where it returns -1, but
it looks like it really wants to return "invalid". The call to
protocol->new in init_conntrack looks like this:

        if (!protocol->new(conntrack, skb)) {
                kmem_cache_free(ip_conntrack_cachep, conntrack);
                return NULL;
        }

so it has to return 0 to say "invalid". Please check if the
attached patch which fixes these places is correct.

Regards
Patrick


--------------090800020606020804060209
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/20 10:06:40+02:00 kaber@coreworks.de 
#   [NETFILTER]: Fix invalid return values from sctp_new
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_sctp.c
#   2004/09/20 10:06:16+02:00 kaber@coreworks.de +5 -5
#   [NETFILTER]: Fix invalid return values from sctp_new
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-20 10:26:10 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-20 10:26:10 +02:00
@@ -430,16 +430,16 @@
 	DEBUGP("\n");
 
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4, &sctph, sizeof(sctph)) != 0)
-		return -1;
+		return 0;
 
 	if (do_basic_checks(conntrack, skb, map) != 0)
-		return -1;
+		return 0;
 
 	/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
 	if ((test_bit (SCTP_CID_ABORT, (void *)map))
 		|| (test_bit (SCTP_CID_SHUTDOWN_COMPLETE, (void *)map))
 		|| (test_bit (SCTP_CID_COOKIE_ACK, (void *)map))) {
-		return -1;
+		return 0;
 	}
 
 	newconntrack = SCTP_CONNTRACK_MAX;
@@ -461,7 +461,7 @@
 
 				if (skb_copy_bits(skb, offset + sizeof (sctp_chunkhdr_t), 
 					&inithdr, sizeof(inithdr)) != 0) {
-						return -1;
+						return 0;
 				}
 
 				DEBUGP("Setting vtag %x for new conn\n", 
@@ -471,7 +471,7 @@
 								inithdr.init_tag;
 			} else {
 				/* Sec 8.5.1 (A) */
-				return -1;
+				return 0;
 			}
 		}
 		/* If it is a shutdown ack OOTB packet, we expect a return

--------------090800020606020804060209--
