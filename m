From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Sun, 01 Jun 2008 23:08:05 +0200
Message-ID: <48430FB5.3070302@trash.net>
References: <483AB493.6010503@trash.net> <200805300933.53869.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46229 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFAVIM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:08:12 -0400
In-Reply-To: <alpine.LNX.1.10.0805301007120.19264@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-05-30 09:33, Thomas Jarosch wrote:
>>>      iptables version 1.4.1-rc2
>> I just compiled the new version and noticed a minor
>> error message during the build of the manpages:
>>
>>  GEN      matches4.man
>> grep: invalid option -- o
>> Usage: grep [OPTION]... PATTERN [FILE]...
>> Try `grep --help' for more information.
>>
>> Looks like my grep version is too old.
> 
> I think it is ok to assume -o is always there. Nov 2001, that's linux
> 2.4.14 timeframe, and most of the now-ancient distros have gone at
> least up to 2.4.20s, which should imply that they also updated their
> greps.
> 
>> Should ./configure detect that
>> or is it even possible to transform the grep call into something else?
> 
> I assume people would not be amused if we start requiring perl.
> But you can use it as a workaround...
> 	perl -ne 'print$&if/\b[A-Z0-9]+\b/'

What exactly is that grep supposed to do? How about sed
or awk?

