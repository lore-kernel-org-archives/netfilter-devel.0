From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 2/5] secmark: make secmark object handling generic
Date: Tue, 12 Oct 2010 13:45:33 -0400
Message-ID: <1286905533.2608.21.camel@dhcp235-107.rdu.redhat.com>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <20101012154015.26943.18385.stgit@paris.rdu.redhat.com>
	 <alpine.LNX.2.01.1010121824540.15529@obet.zrqbmnf.qr>
	 <4CB499E3.5030305@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	paul.moore@hp.com, jmorris@namei.org, selinux@tycho.nsa.gov,
	sds@tycho.nsa.gov, linux-security-module@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0JLRrB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Oct 2010 13:47:01 -0400
In-Reply-To: <4CB499E3.5030305@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2010-10-12 at 19:24 +0200, Pablo Neira Ayuso wrote:
> On 12/10/10 18:26, Jan Engelhardt wrote:
> > On Tuesday 2010-10-12 17:40, Eric Paris wrote:

> >> static struct xt_target secmark_tg_reg __read_mostly = {
> >> -	.name       = "SECMARK",
> >> -	.revision   = 0,
> >> -	.family     = NFPROTO_UNSPEC,
> >> -	.checkentry = secmark_tg_check,
> >> -	.destroy    = secmark_tg_destroy,
> >> -	.target     = secmark_tg,
> >> -	.targetsize = sizeof(struct xt_secmark_target_info),
> >> -	.me         = THIS_MODULE,
> >> +	.name		= "SECMARK",
> >> +	.revision	= 0,
> >> +	.family		= NFPROTO_UNSPEC,
> >> +	.checkentry	= secmark_tg_check,
> >> +	.destroy	= secmark_tg_destroy,
> >> +	.target		= secmark_tg,
> >> +	.targetsize	= sizeof(struct xt_secmark_target_info),
> >> +	.me		= THIS_MODULE,
> >> };
> 
> I think that we don't need that extra tab above.

Are you saying that you prefer lots of spaces to get alignment rather
than the single tab?  I see examples of both in other struct xt_target
definitions.  I didn't make any syntax changes to this struct, so my
guess is that I made this change when I discovered eight spaces in a row
as I was checking the file for tab->space screw-ups before submission.
Since this is a whitespace change in the middle of a real patch I guess
I can drop the hunk entirely if that's what you are asking for....

-Eric


