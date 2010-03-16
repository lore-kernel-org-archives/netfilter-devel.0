From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ebtables-2.0.9-2: build fixes
Date: Tue, 16 Mar 2010 11:44:16 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003161141460.27631@obet.zrqbmnf.qr>
References: <1268725978.19121.3.camel@tablet> <4B9F5DF9.2080007@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Volkov <pva@gentoo.org>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59935 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397Ab0CPKoR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:44:17 -0400
In-Reply-To: <4B9F5DF9.2080007@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-16 11:31, Bart De Schuymer wrote:
>> 
>> 1. ebtables-v2.0.9-2-LDFLAGS.diff - respect LDFLAGS during ebtables
>> build.
>> 2. ebtables-v2.0.8-2-ethertype-DESTDIR-mkdir.patch - create directories
>> to avoid build failure when DESTDIR is supplied.
>
>Thanks for the patches. I have some questions, though.
>- In what situation is LDFLAGS needed (it's not defined in the
>Makefiles)? Is it standard practice to include this?

LDFLAGS=-m32 and LDFLAGS=-Wl,--as-needed are two examples for
this decade.

>- Not all distros use the sysvinit package anymore (e.g. Ubuntu uses
>upstart). In arptables I made the copying to INITDIR and SYSCONFIGDIR
>dependent on the existence of the directories. That way we don't copy
>the sysvinit type of files on a system that uses something else. I'd
>prefer to do the same thing with ebtables. Does that sound ok to you?

That sounds wrong to me. Chroots building software may have fewer
directories than the Makefiles expect, so it's best not to install
too few files. Deleting files in buildscripts is easier on the mind
than postinstalling them.
