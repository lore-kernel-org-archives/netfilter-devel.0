From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arptables 0.0.3-4 build fixes
Date: Tue, 16 Mar 2010 16:27:58 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003161617120.10927@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1003161144290.27631@obet.zrqbmnf.qr> <4B9F8499.1060104@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54291 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966335Ab0CPP2A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:28:00 -0400
In-Reply-To: <4B9F8499.1060104@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-16 14:16, Bart De Schuymer wrote:
>> 
>> from my side two build patches for arptables.
>> 
>> (1) Do not call install with -o or -g, because it makes unprivileged 
>> installs (used by build chroots) fail. Autotools does not use -o or -g 
>> either, so the usage is consistent and does what was inteded when root
>> is running `make install`.
>> 
>> (2) Fixing all the compiler warnings that turned up about printf 
>> formatting and strict-aliasing.
>
>Someone once insisted using this -o -g usage long ago and no
>distributors have complained about it yet,

Fedora ships arptables_jf, which does not use -o,-g, thus does not have
a problem to report.

OpenSUSE shipped arptables_jf. I moved it back to arptables
because the jf fork is in an uncertain state.

Debian either builds with root or has patched install(1).

>so I'm going to leave it in
>for now. Plenty of other projects do it this way too.

Well it is wrong, and I can list many more projects (namely:
everything using automake's built-in installation) that do it the
right way instead.

If you are still not convinced: running automake's `make install`
as root will (which you will have to do to even be eligible to
install it to system locations), surprise surprise, install the
files as root. So it's doing the right thing in both cases.

>The warings that occur when using llu with 64-bit numbers should be
>resolved with the PRIu64 macro. Could you fix that and resubmit, please?
>Thanks.

Hmm, iptables is not using PRI either so it seemed like the preferred
approach.
