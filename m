From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: partially implement
 ctnetlink_change_expect
Date: Mon, 7 May 2012 20:54:03 +0200
Message-ID: <20120507185403.GB3859@1984>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
 <1336005564-23171-3-git-send-email-kelvie@ieee.org>
 <20120506230915.GA23306@1984>
 <CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
 <20120507084228.GA27334@1984>
 <CAK2bC5o7dxrum59D6fmxsTvSmbWGXbgMeDASW5H1XFtB1=rhEw@mail.gmail.com>
 <20120507164324.GA3824@kwong-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kelvie Wong <kelvie@ieee.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44784 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab2EGSyS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 14:54:18 -0400
Content-Disposition: inline
In-Reply-To: <20120507164324.GA3824@kwong-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 09:43:24AM -0700, Kelvie Wong wrote:
> On Mon, May 07, 2012 at 09:28:58AM -0700, Kelvie Wong wrote:
> > That will be fine.
> > 
> > Thank you,
> > -- 
> > Kelvie Wong
> 
> Here's the patch if you don't want to do the work :)
> 
> From 2fa0ea4c54ad8b16e7978f8d41892f4d33b0db65 Mon Sep 17 00:00:00 2001
> From: Kelvie Wong <kelvie@ieee.org>
> Date: Mon, 7 May 2012 09:30:55 -0700
> Subject: [PATCH] netfilter: nf_ct_expect: partially implement
>  ctnetlink_change_expect
> 
> This refreshes the "timeout" attribute in existing expectations if one is
> given.
> 
> The use case for this would be for userspace helpers to extend the lifetime
> of the expectation when requested, as this is not possible right now
> without deleting/recreating the expectation.
> 
> I use this specifically for forwarding DCERPC traffic through:
> 
> DCERPC has a port mapper daemon that chooses a (seemingly) random port for
> future traffic to go to. We expect this traffic (with a reasonable
> timeout), but sometimes the port mapper will tell the client to continue
> using the same port. This allows us to extend the expectation accordingly.
> 
> Signed-off-by: Kelvie Wong <kelvie@ieee.org>

Applied, thanks Kelvie.
