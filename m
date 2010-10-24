From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: don't always initialize ct->proto
Date: Sun, 24 Oct 2010 10:27:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010241019360.5890@obet.zrqbmnf.qr>
References: <1287888016-25213-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47346 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab0JXI1I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 04:27:08 -0400
In-Reply-To: <1287888016-25213-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2010-10-24 04:40, Changli Gao wrote:

>ct->proto is big(60 bytes) due to structure ip_ct_tcp, and we don't need
>to initialize the whole for all the other protocols. This patch moves
>proto to the end of structure nf_conn, and pushes the initialization down
>to the individual protocols.
>
>diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
>index 5292560..9ae57c5 100644
>--- a/net/netfilter/nf_conntrack_proto_dccp.c
>+++ b/net/netfilter/nf_conntrack_proto_dccp.c
>@@ -452,6 +452,9 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
> 	ct->proto.dccp.role[IP_CT_DIR_ORIGINAL] = CT_DCCP_ROLE_CLIENT;
> 	ct->proto.dccp.role[IP_CT_DIR_REPLY] = CT_DCCP_ROLE_SERVER;
> 	ct->proto.dccp.state = CT_DCCP_NONE;
>+	ct->proto.dccp.last_pkt = DCCP_PKT_REQUEST;
>+	ct->proto.dccp.last_dir = IP_CT_DIR_ORIGINAL;
>+	ct->proto.dccp.handshake_seq = 0;
> 	return true;
> 
> out_invalid:

This hunk seems unrelated to the actual move of the union member -

>diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
>index c4c885d..69da4b0 100644
>--- a/net/netfilter/nf_conntrack_proto_tcp.c
>+++ b/net/netfilter/nf_conntrack_proto_tcp.c
>@@ -1066,9 +1066,7 @@ static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
> 	BUG_ON(th == NULL);
> 
> 	/* Don't need lock here: this conntrack not in circulation yet */
>-	new_state
>-		= tcp_conntracks[0][get_conntrack_index(th)]
>-		[TCP_CONNTRACK_NONE];
>+	new_state = tcp_conntracks[0][get_conntrack_index(th)][TCP_CONNTRACK_NONE];
> 
> 	/* Invalid: delete conntrack */
> 	if (new_state >= TCP_CONNTRACK_MAX) {

as does this change. Can you elaborate on why they are now needed,
or did you happen to erroneously squash multiple patches?
