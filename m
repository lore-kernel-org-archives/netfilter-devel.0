From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libmnl: security context retrieval in nf-queue example
Date: Tue, 30 Jun 2015 17:33:03 +0200
Message-ID: <20150630153303.GA5925@salvia>
References: <20150610160541.GD7125@breakpoint.cc>
 <55798582.1040903@samsung.com>
 <20150611233757.GE7125@breakpoint.cc>
 <557AB559.1000001@samsung.com>
 <20150612130240.GA29551@salvia>
 <558015A9.8060703@samsung.com>
 <20150616123706.GA32486@salvia>
 <55801D8A.9050701@samsung.com>
 <20150616152522.GA3959@salvia>
 <55804B77.1030207@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32774 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbbF3P1l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Jun 2015 11:27:41 -0400
Content-Disposition: inline
In-Reply-To: <55804B77.1030207@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 06:14:47PM +0200, Roman Kubiak wrote:
> Below is a complete libnetfilter_queue patch:
> 
> 
> [PATCH] libnetfilter_queue: add security context information
> 
> This commit adds security context information structures
> and functions.
> 
> This will allow userspace to find the security context of each
> packet (if it exists) and make decisions based on that.
> It should work for SELinux and SMACK.

Applied with minor glitch. Thanks.

> @@ -76,7 +80,7 @@ static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
>  {
>  	uint32_t id = print_pkt(nfa);
>  	printf("entering callback\n");
> -	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
> +	return nfq_set_verdict2(qh, id, NF_ACCEPT, 0x3, 0, NULL);

I have kept back this chunk to set the packet mark to 3. It doesn't
belong here.
