From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables-2.0.9-2: build fixes
Date: Tue, 16 Mar 2010 11:31:21 +0100
Message-ID: <4B9F5DF9.2080007@pandora.be>
References: <1268725978.19121.3.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:35667 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0CPKbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:31:24 -0400
In-Reply-To: <1268725978.19121.3.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Volkov wrote:
> Hello. I hope this is correct mailing list to post patches for ebtables.
> Please, review and apply attached patches for ebtables:
> 
> 1. ebtables-v2.0.9-2-LDFLAGS.diff - respect LDFLAGS during ebtables
> build.
> 2. ebtables-v2.0.8-2-ethertype-DESTDIR-mkdir.patch - create directories
> to avoid build failure when DESTDIR is supplied.
> 
> With best regards,
> 

Hello Peter,

Thanks for the patches. I have some questions, though.
- In what situation is LDFLAGS needed (it's not defined in the
Makefiles)? Is it standard practice to include this?
- Not all distros use the sysvinit package anymore (e.g. Ubuntu uses
upstart). In arptables I made the copying to INITDIR and SYSCONFIGDIR
dependent on the existence of the directories. That way we don't copy
the sysvinit type of files on a system that uses something else. I'd
prefer to do the same thing with ebtables. Does that sound ok to you?

cheers,

Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
