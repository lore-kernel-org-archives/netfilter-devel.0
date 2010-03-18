From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: arptables 0.0.3-4 build fixes
Date: Thu, 18 Mar 2010 09:29:10 +0100
Message-ID: <4BA1E456.10305@pandora.be>
References: <alpine.LSU.2.01.1003161144290.27631@obet.zrqbmnf.qr> <4B9F8499.1060104@pandora.be> <alpine.LSU.2.01.1003161617120.10927@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:33265 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0CRI3M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:29:12 -0400
In-Reply-To: <alpine.LSU.2.01.1003161617120.10927@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-03-16 14:16, Bart De Schuymer wrote:
>>> from my side two build patches for arptables.
>>>
>>> (1) Do not call install with -o or -g, because it makes unprivileged 
>>> installs (used by build chroots) fail. Autotools does not use -o or -g 
>>> either, so the usage is consistent and does what was inteded when root
>>> is running `make install`.
>>>
>>> (2) Fixing all the compiler warnings that turned up about printf 
>>> formatting and strict-aliasing.
>> Someone once insisted using this -o -g usage long ago and no
>> distributors have complained about it yet,
> 
> Fedora ships arptables_jf, which does not use -o,-g, thus does not have
> a problem to report.
> 
> OpenSUSE shipped arptables_jf. I moved it back to arptables
> because the jf fork is in an uncertain state.
> 

Yeah, too bad Redhat was so mysterious about this. The command line
options aren't even compatible. I wouldn't mind if arptables_jf became
the version used by all distros, but I'll maintain my own version as
long as it's used. On my laptop arptables_jf version 0.0.8 segfaults
with -L (built from sources).
I'll remove the -o -g stuff in ebtables' and arptables' Makefiles :-)

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
