From: Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH nf-next] netfilter: bridge: use rcu hook to resolve
 br_netfilter dependency
Date: Wed, 11 Mar 2015 08:58:54 +0900
Message-ID: <20150310235852.GA18265@vergenet.net>
References: <1425986755-3648-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33815 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbCJX7F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 19:59:05 -0400
Received: by pdno5 with SMTP id o5so6276320pdn.1
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2015 16:59:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1425986755-3648-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 10, 2015 at 12:25:55PM +0100, Pablo Neira Ayuso wrote:
> e5de75b ("netfilter: bridge: move DNAT helper to br_netfilter") results
> in the following link problem:
> 
> net/bridge/br_device.c:29: undefined reference to `br_nf_prerouting_finish_bridge`
> 
> Moreover it creates a hard dependency between br_netfilter and the
> bridge core, which is what we've been trying to avoid so far.
> 
> Resolve this problem by using a hook structure so we reduce #ifdef
> pollution and keep bridge netfilter specific code under br_netfilter.c
> which was the original intention.
> 
> Reported-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks, I have confirmed that this resolves the link problem.

Reviewed-by: Simon Horman <simon.horman@netronome.com>
