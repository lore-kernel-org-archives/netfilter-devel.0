From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Fri, 30 May 2008 10:17:57 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr>
References: <483AB493.6010503@trash.net> <200805300933.53869.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48907 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYE3IR7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 04:17:59 -0400
In-Reply-To: <200805300933.53869.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-05-30 09:33, Thomas Jarosch wrote:

>Hello Patrick,
>
>On Monday, 26. May 2008 15:01:07 you wrote:
>> The netfilter coreteam proudly presents:
>>
>>      iptables version 1.4.1-rc2
>
>I just compiled the new version and noticed a minor
>error message during the build of the manpages:
>
>  GEN      matches4.man
>grep: invalid option -- o
>Usage: grep [OPTION]... PATTERN [FILE]...
>Try `grep --help' for more information.
>
>Looks like my grep version is too old.


Revision 1.72 - (view) (download) (as text) (annotate) - [select for diffs]
Mon Nov 19 13:23:29 2001 UTC (6 years, 6 months ago) by bero
Branch: MAIN
Changes since 1.71: +34 -1 lines
Diff to previous 1.71

Add -o option


I think it is ok to assume -o is always there. Nov 2001, that's linux
2.4.14 timeframe, and most of the now-ancient distros have gone at
least up to 2.4.20s, which should imply that they also updated their
greps.

>Should ./configure detect that
>or is it even possible to transform the grep call into something else?

I assume people would not be amused if we start requiring perl.
But you can use it as a workaround...
	perl -ne 'print$&if/\b[A-Z0-9]+\b/'
