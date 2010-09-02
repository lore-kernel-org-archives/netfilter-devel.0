From: rui.sousa@mindspeed.com
Subject: Re: TCP proto info
Date: Thu, 2 Sep 2010 11:21:26 +0200
Message-ID: <OF4265BCAA.61F095B7-ONC1257792.0032E48D-C1257792.00337F58@mindspeed.com>
References: <4C7F6703.2080704@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail203.messagelabs.com ([216.82.254.243]:25671 "HELO
	mail203.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751677Ab0IBJWa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:22:30 -0400
In-Reply-To: <4C7F6703.2080704@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote on 09/02/2010 10:57:39 AM:

> Hi Rui,

Hi Pablo,

> On 01/09/10 15:45, rui.sousa@mindspeed.com wrote:
> > Hi,
> > 
> > I have an application using libnetfilter_conntrack-0.100 that started 
> > reporting errors after the commit: 
> > 
> > 1c450e1595afdc8d1bfabb4f640c9251808426eb.
> 
> Looking at the source code, this seems to be already fixed in
> libnetfilter_conntrack 0.0.102, please upgrade to latest.

Hmm... looking at the git tree I see that the __build_conntrack() code is
still calling __build_protoinfo() unconditionally and inside the function
we always do:

nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_TCP);
...
nfnl_nest_end(&req->nlh, nest_proto);
nfnl_nest_end(&req->nlh, nest);

even if none of the ATTR_TCP_xxx bits are set. This is what causes the 
kernel to return -EINVAL
and ignore the conntrack update. Or am I missing something?

Br,
Rui
