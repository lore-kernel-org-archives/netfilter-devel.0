From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD2 PATCH] Use attribute to avoid warning about unused
	parameter.
Date: Thu, 31 Jul 2008 17:11:54 +0200
Message-ID: <20080731151153.GH30655@khasse.inl.fr>
References: <48918F6D.8040307@trash.net> <1217512238-26173-1-git-send-email-eric@inl.fr> <4891D029.9090702@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44303 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYGaPL4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:11:56 -0400
Content-Disposition: inline
In-Reply-To: <4891D029.9090702@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thursday, 2008 July 31 at 16:46:01 +0200, Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
> > Following live discussion with Pierre Chifflier, it appears that the flag
> > -Wno-unused-parameter is deprecated in gcc and has to be replaced by an
> > attribute: __attribute__ ((unused)).
> > 
> > The following patch fixes all warnings related to unused parameters by
> > correctly settings the attribute in all unused function parameters. This
> > is mainly the case for callback functions. It uses a macro named UNUSED
> > which is simply defined as __attribute__((unused)).
> 
> I don't like polluting the code with tons of UNUSED flags, sorry.

I don't like that too.

> I prefer if we use several -Wxyz options that may be report useful
> warnings instead of -Wextra.

But, the fact is that globally switching the flag can be a way to
miss some really useful warning. Patch 03/11 of this patchset
was done after seing a gcc warning.

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
