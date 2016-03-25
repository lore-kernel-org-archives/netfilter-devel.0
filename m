From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH] netfilter: ipv4: fix NULL dereference
Date: Fri, 25 Mar 2016 11:49:42 +0100
Message-ID: <20160325104942.GC7956@salvia>
References: <1458743250-4003-1-git-send-email-zlpwmdx@163.com>
 <20160324202205.GA2167@salvia>
 <21bea8ab.6e3f.153ac7eaa52.Coremail.zlpwmdx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	davem@davemloft.net, kernel@kyup.com,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpwmdx@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39187 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbcCYKtx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2016 06:49:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D2F42C1254
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2016 11:49:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8372CDA8F8
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2016 11:49:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D378DA8FB
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2016 11:49:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <21bea8ab.6e3f.153ac7eaa52.Coremail.zlpwmdx@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 25, 2016 at 02:38:15PM +0800, Liping Zhang wrote:
> At 2016-03-25 04:22:05, "Pablo Neira Ayuso" <pablo@netfilter.org> wrote:
> >
> >Could you also pass net as parameter to synproxy_send_server_syn() ?
> >
> >par->net provides this from synproxy_tg4().
> 
> Not pass the net but replace the first parameter 'snet' with 'net' seems better?
> snet is only used in synproxy_recv_client_ack->synproxy_send_server_syn call path,
> and in other call path, actually we only need net,  and we can call synproxy_pernet(net)
> to get the snet.
> 
> like follows:
> -synproxy_send_server_syn(const struct synproxy_net *snet,
> +synproxy_send_server_syn(struct net *net,
> 
> -synproxy_recv_client_ack(const struct synproxy_net *snet,
> +synproxy_recv_client_ack(struct net *net,
>                          const struct sk_buff *skb, const struct tcphdr *th,
>                          struct synproxy_options *opts, u32 recv_seq)
>  {
> +       struct synproxy_net *snet = synproxy_pernet(net);

Fine with me.
