From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2/NFLOG: nfnetlink_log: error creating log nlmsg
Date: Thu, 21 May 2009 19:24:58 +0200
Message-ID: <4A158E6A.8090705@netfilter.org>
References: <1242842730.8076.60.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040207010803010807010907"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56967 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZEURms (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2009 13:42:48 -0400
In-Reply-To: <1242842730.8076.60.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040207010803010807010907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thomas Jacob wrote:
> Hello List,
> 
> I am trying to get ulogd2 to log NFLOG-collected data
> correctly, and am getting lots of "nfnetlink_log: error creating log
> nlmsg" and only very few actual log entries.
> 
> As far as I can tell this happens when there is not enough skb_tailroom
> for the log-message in __build_packet_message, but in
> nfulnl_log_packet there also a check of skb_tailroom against a different
> size value which is supposed to result in flushing messages if there
> is no space.
> 
> Bug? Feature? If it's the latter, how can I prevent this from
> happening?

Does this patch helps? It seems that we're missing to add the size of
the hardware address since 2.6.27.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040207010803010807010907
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fd326ac..66a6dd5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -581,6 +581,12 @@ nfulnl_log_packet(u_int8_t pf,
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
 
+	if (in && skb_mac_header_was_set(skb)) {
+		size +=   nla_total_size(skb->dev->hard_header_len)
+			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
+			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
+	}
+
 	spin_lock_bh(&inst->lock);
 
 	if (inst->flags & NFULNL_CFG_F_SEQ)

--------------040207010803010807010907--
