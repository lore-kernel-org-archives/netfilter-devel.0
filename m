From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/2 nft] ct: add missing slash to connlabel path
Date: Wed, 17 Aug 2016 13:36:07 +0200
Message-ID: <20160817113607.GD10778@breakpoint.cc>
References: <1471432383-4318-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47420 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902AbcHQLgK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 07:36:10 -0400
Content-Disposition: inline
In-Reply-To: <1471432383-4318-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If I configure nftables via:
> 
> 	./configure --prefix=/usr
> 
> the connlabel path breaks due to missing slash, so append this after
> DEFAULT_INCLUDE_PATH.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Florian Westphal <fw@strlen.de>
