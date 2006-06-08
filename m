From: Jorge Matias Martin <jorge.matias@motorola.com>
Subject: [PATCH] xt_sctp - add SCTP header size to IP header offset
Date: Thu, 8 Jun 2006 17:54:08 +0200
Message-ID: <200606081754.09073.jorge.matias@motorola.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hgEiETCXEYO++0h"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

--Boundary-00=_hgEiETCXEYO++0h
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, all.

xt_sctp module is not working on 2.6.16 when --chunk-types option is used. I 
have test this running sctp_darn and the following iptables options:

-A INPUT -p sctp --chunk-types any INIT -j DROP

And this is the kernel log output:

spt: 32822    dpt: 10105
Chunk num: 1  offset: 20      type: 128       length: 10105   flags: 36
skb->len: 92  offset: 10128
spt: 10105    dpt: 32822
Chunk num: 1  offset: 20      type: 39        length: 32822   flags: 79
skb->len: 284 offset: 32844
spt: 32822    dpt: 10105
Chunk num: 1  offset: 20      type: 128       length: 10105   flags: 36
...


Note that length is actually the local port, and offset must be 32 (20 IPv4 
header + 12 SCTP header).

FYI, it works properly when --chunk-types is not used.


Regards.

Jorge. 

--Boundary-00=_hgEiETCXEYO++0h
Content-Type: text/x-diff;
  charset="us-ascii";
  name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patch"

--- linux-2.6.16.19/net/netfilter/xt_sctp.c.orig	2006-05-31 02:31:44.000000000 +0200
+++ linux-2.6.16.19/net/netfilter/xt_sctp.c	2006-06-08 17:32:53.000000000 +0200
@@ -152,7 +152,7 @@ match(const struct sk_buff *skb,
 		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0]) 
 			&& (ntohs(sh->dest) <= info->dpts[1])), 
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
-		&& SCCHECK(match_packet(skb, protoff,
+		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
 					info->chunkmap, info->chunk_match_type,
  					info->flag_info, info->flag_count, 
 					hotdrop),

--Boundary-00=_hgEiETCXEYO++0h--
