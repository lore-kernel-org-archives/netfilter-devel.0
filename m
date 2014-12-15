From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/4] datatype: missing byteorder in string_type
Date: Mon, 15 Dec 2014 18:24:02 +0100
Message-ID: <20141215172402.GA4708@salvia>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
 <1418576463-3606-2-git-send-email-pablo@netfilter.org>
 <4D4832DE-212B-481E-935D-D7B1833D3549@trash.net>
 <20141214194708.GA17579@salvia>
 <20141215114332.GA3665@salvia>
 <4ADDD44D-642B-4E56-9A86-39FF987FBCC6@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49466 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaLORVk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:21:40 -0500
Content-Disposition: inline
In-Reply-To: <4ADDD44D-642B-4E56-9A86-39FF987FBCC6@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 15, 2014 at 03:16:19PM +0100, Patrick McHardy wrote:
> Am 15. Dezember 2014 12:43:32 MEZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
> >Hi Patrick!
> >
> >On Sun, Dec 14, 2014 at 08:47:08PM +0100, Pablo Neira Ayuso wrote:
> >> On Sun, Dec 14, 2014 at 07:01:10PM +0100, Patrick McHardy wrote:
> >> > Am 14. Dezember 2014 18:01:00 MEZ, schrieb Pablo Neira Ayuso
> ><pablo@netfilter.org>:
> >> > >nft add rule filter input iifname { "lo", "eth0" } counter
> >> > >
> >> > >Now the listing shows:
> >> > >
> >> > >	iifname { "lo", "eth0"}
> >> > >
> >> > >instead of:
> >> > >
> >> > >	iifname { "", ""}
> >> > 
> >> > Again wondering what broke this. Let me check when I am at home,
> >> > IIRC we have some check for strings somewhere in the netlink code
> >> > that relies in this.
> >> 
> >> Attached an alternative to this patch. That I can remember, this is
> >> broken since quite some time.
> >
> >Any concern with this second approach?
> >
> >Let me know if you prefer I keep this away from this release.
> 
> Actually the first one is fine, I thought it would affect string
> postprocessing in delinearization, but it's fine.

Thanks Patrick! I have applied the first patch.
