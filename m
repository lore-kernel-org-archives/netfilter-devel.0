From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH lnf-ct] conntrack: fix stop timestamp assignment
Date: Tue, 7 Jul 2015 11:50:59 +0200
Message-ID: <20150707095059.GI16864@breakpoint.cc>
References: <20150707042904.GA7944@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32869 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbbGGJvB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jul 2015 05:51:01 -0400
Content-Disposition: inline
In-Reply-To: <20150707042904.GA7944@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
>  	if (tb[CTA_TIMESTAMP_STOP]) {
>  		ct->timestamp.stop =
> -			be64toh(mnl_attr_get_u64(tb[CTA_TIMESTAMP_START]));
> +			be64toh(mnl_attr_get_u64(tb[CTA_TIMESTAMP_STOP]));
>  		set_bit(ATTR_TIMESTAMP_STOP, ct->head.set);

Good catch, applied, thanks a lot!
