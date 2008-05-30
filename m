From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Fri, 30 May 2008 10:26:54 +0200
Message-ID: <200805301026.54905.thomas.jarosch@intra2net.com>
References: <483AB493.6010503@trash.net> <200805300933.53869.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:47455 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYE3I1A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 04:27:00 -0400
In-Reply-To: <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

> Revision 1.72 - (view) (download) (as text) (annotate) - [select for diffs]
> Mon Nov 19 13:23:29 2001 UTC (6 years, 6 months ago) by bero
> Branch: MAIN
> Changes since 1.71: +34 -1 lines
> Diff to previous 1.71
>
> Add -o option
>
>
> I think it is ok to assume -o is always there. Nov 2001, that's linux
> 2.4.14 timeframe, and most of the now-ancient distros have gone at
> least up to 2.4.20s, which should imply that they also updated their
> greps.

Well, I run kernel 2.6.24 and never had a need to upgrade grep until now.
But I'm fine with the new version, just wanted to report it.

> >Should ./configure detect that
> >or is it even possible to transform the grep call into something else?
>
> I assume people would not be amused if we start requiring perl.
> But you can use it as a workaround...
> 	perl -ne 'print$&if/\b[A-Z0-9]+\b/'

That's true, though I guess there is a "sed" wizard out there
that can easily rewrite the call into a sed command,
which should be available on most (ancient) systems ;-)

Thomas
