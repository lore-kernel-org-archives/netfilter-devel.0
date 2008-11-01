From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Sat, 1 Nov 2008 02:10:30 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr> <490B544B.50903@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Rick Jones <rick.jones2@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52203 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKABKc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2008 21:10:32 -0400
In-Reply-To: <490B544B.50903@hp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-10-31 19:54, Rick Jones wrote:
>> 
>> iptables-save | grep ^- | wc -l
>
> Here is where I cop to being a luddite who prefers straight C to calling
> system() :)

But there is no C library. And libiptc is so strongly internal that
it does not fall under libraries-to-use.

>> And strace should not be taught that. We have seen at least one
>> change of the interpretation of the binary stream.
>
> How about at least the option name(s) so it can present something other than
> the 0x40/0x41 etc?

I do not mind that. Turn to the strace maintainer about getting that
implemented.
