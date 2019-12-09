Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4797AC43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 21:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8B97205C9
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 21:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="RefOeL0i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfLIVmL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 16:42:11 -0500
Received: from kadath.azazel.net ([81.187.231.250]:37682 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfLIVmL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 16:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+fTcXD7k9vMx+aLiTmUwfhJ6AGKasnjxVUzl3pD47oM=; b=RefOeL0i8NzortQTMOAyCrv5NZ
        1Q3N4RZm0bXzI7I79gLO/krCK6Mkms9PP4Qrk696HwE96vySArFN3FEWi0JnHxwGK+XzXrGQLIdo/
        URzMjho8kOctleZclIVJSw4eTN2rDWywGu98afDnq3x7AKfyJ14Ub1HuEYIzEcpZTnMJJq+SJawL5
        nwOhWgOchd5cfNYh/q+X1uRZJAPCsKOsrN4AcsdE+AMBEspSqZTVPcnJ1f8Jh8ZCEofZmmRdJxjeN
        vmTBTN+XqQBEGhVPuQU9fE196sposjVwkDJZVFJfWHkDj0X+1iovoxw0u6jq0U2Eu6l3qSqRAGW1Q
        SoAj5KWQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ieQnA-0002JY-CA; Mon, 09 Dec 2019 21:42:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [RFC PATCH nf-next] netfilter: conntrack: add support for storing DiffServ code-point as CT mark.
Date:   Mon,  9 Dec 2019 21:42:08 +0000
Message-Id: <20191209214208.852229-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

"ct dscpmark" is a method of storing the DSCP of an ip packet into the
conntrack mark.  In combination with a suitable tc filter action
(act_ctinfo) DSCP values are able to be stored in the mark on egress and
restored on ingress across links that otherwise alter or bleach DSCP.

This is useful for qdiscs such as CAKE which are able to shape according
to policies based on DSCP.

Ingress classification is traditionally a challenging task since
iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
lookups, hence are unable to see internal IPv4 addresses as used on the
typical home masquerading gateway.

The "ct dscpmark" conntrack statement solves the problem of storing the
DSCP to the conntrack mark in a way suitable for the new act_ctinfo tc
action to restore.

The "ct dscpmark" statement accepts 2 parameters, a 32bit 'dscpmask' and a
32bit 'statemask'.  The dscp mask must be 6 contiguous bits and
represents the area where the DSCP will be stored in the connmark.  The
state mask is a minimum 1 bit length mask that must not overlap with the
dscpmask.  It represents a flag which is set when the DSCP has been
stored in the conntrack mark. This is useful to implement a 'one shot'
iptables based classification where the 'complicated' iptables rules are
only run once to classify the connection on initial (egress) packet and
subsequent packets are all marked/restored with the same DSCP.  A state
mask of zero disables the setting of a status bit/s.

For example,

  table ip t {
    chain c {
      type filter hook postrouting priority mangle; policy accept;
      oif eth0 ct dscpmark set 0xfc000000/0x01000000
    }
  }

would store the DSCP in the top 6 bits of the 32bit mark field, and use
the LSB of the top byte as the 'DSCP has been stored' marker.

|----0xFC----conntrack mark----000000---|
| Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
| DSCP       | unused | flag  |unused   |
|-----------------------0x01---000000---|
      ^                   ^
      |                   |
      ---|             Conditional flag
         |             set this when dscp
|-ip diffserv-|        stored in mark
| 6 bits      |
|-------------|

an identically configured tc action to restore looks like:

  tc filter show dev eth0 ingress
  filter parent ffff: protocol all pref 10 u32 chain 0
  filter parent ffff: protocol all pref 10 u32 chain 0 fh 800: ht divisor 1
  filter parent ffff: protocol all pref 10 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1: not_in_hw
    match 00000000/00000000 at 0
          action order 1: ctinfo zone 0 pipe
           index 2 ref 1 bind 1 dscp 0xfc000000/0x1000000

          action order 2: mirred (Egress Redirect to device ifb4eth0) stolen
          index 1 ref 1 bind 1

|----0xFC----conntrack mark----000000---|
| Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
| DSCP       | unused | flag  |unused   |
|-----------------------0x01---000000---|
      |                   |
      |                   |
      ---|             Conditional flag
         v             only restore if set
|-ip diffserv-|
| 6 bits      |
|-------------|

Suggested-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/Kconfig                    |  7 ++++++
 net/netfilter/nft_ct.c                   | 32 ++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bb9b049310df..bc69fb904783 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -984,6 +984,7 @@ enum nft_socket_keys {
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
  * @NFT_CT_ID: conntrack id
+ * @NFT_CT_DSCPMARK: conntrack DSCP mark
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -1010,6 +1011,7 @@ enum nft_ct_keys {
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
 	NFT_CT_ID,
+	NFT_CT_DSCPMARK,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae88e8c2..d17c87aab667 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -91,6 +91,13 @@ config NF_CONNTRACK_MARK
 	  of packets, but this mark value is kept in the conntrack session
 	  instead of the individual packets.
 
+config NF_CONNTRACK_DSCPMARK
+	bool  'DSCP connection mark tracking support'
+	depends on NF_CONNTRACK_MARK
+	help
+	  This option enables support for copying the DiffServ code-point
+	  from a packet's IP header and storing it as the connection mark.
+
 config NF_CONNTRACK_SECMARK
 	bool  'Connection tracking security mark support'
 	depends on NETWORK_SECMARK
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 46ca8bcca1bd..bdd32307462c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -301,6 +301,31 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_DSCPMARK
+	case NFT_CT_DSCPMARK: {
+		u64 ct_dscpmark;
+		u32 dscpshift, statemask, dscp;
+
+		ct_dscpmark = nft_reg_load64(&regs->data[priv->sreg]);
+
+		dscpshift = ct_dscpmark >> 32;
+		statemask = ct_dscpmark & 0xffffffff;
+
+		if (skb->protocol == htons(ETH_P_IP))
+			dscp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
+		else if (skb->protocol == htons(ETH_P_IPV6))
+			dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
+		else    /* protocol doesn't have diffserv */
+			break;
+
+		value = (dscp << dscpshift) | statemask;
+		if (ct->mark != value) {
+			ct->mark = value;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	}
+#endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	case NFT_CT_SECMARK:
 		if (ct->secmark != value) {
@@ -554,6 +579,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		len = FIELD_SIZEOF(struct nf_conn, mark);
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_DSCPMARK
+	case NFT_CT_DSCPMARK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+		len = FIELD_SIZEOF(struct nf_conn, mark) * 2;
+		break;
+#endif
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	case NFT_CT_LABELS:
 		if (tb[NFTA_CT_DIRECTION])
-- 
2.24.0

