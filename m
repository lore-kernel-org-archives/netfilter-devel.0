From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnf-queue] src: PF_BIND/UNBIND is ignored in 3.8 and later
Date: Thu, 24 Apr 2014 12:09:10 +0200
Message-ID: <20140424100910.GC13717@breakpoint.cc>
References: <1398330071-3463-1-git-send-email-fw@strlen.de>
 <20140424100105.GA8151@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36676 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434AbaDXKJL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:09:11 -0400
Content-Disposition: inline
In-Reply-To: <20140424100105.GA8151@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > -	nlh = nfq_hdr_put(buf, NFQNL_MSG_CONFIG, 0);
> > -	nfq_nlmsg_cfg_put_cmd(nlh, AF_INET, NFQNL_CFG_CMD_PF_UNBIND);
> > -
> > -	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> > -		perror("mnl_socket_send");
> > -		exit(EXIT_FAILURE);
> > -	}
> > -
> > +	/* PF_BIND is not needed with kernels 3.8 and later */
> 
> My only concern is that people using old kernels won't manage to run
> this example, I think there are quite a lot of people running < 3.8,
> so we may hit confusion from the other side.

I pushed the patch without the UNBIND removal.

Thanks.
