From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables-2.0.9-2: build fixes
Date: Tue, 16 Mar 2010 12:21:56 +0100
Message-ID: <4B9F69D4.2030709@pandora.be>
References: <1268725978.19121.3.camel@tablet> <4B9F5DF9.2080007@pandora.be> <alpine.LSU.2.01.1003161141460.27631@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Volkov <pva@gentoo.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:59970 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937816Ab0CPLV7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 07:21:59 -0400
In-Reply-To: <alpine.LSU.2.01.1003161141460.27631@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:

>> - Not all distros use the sysvinit package anymore (e.g. Ubuntu uses
>> upstart). In arptables I made the copying to INITDIR and SYSCONFIGDIR
>> dependent on the existence of the directories. That way we don't copy
>> the sysvinit type of files on a system that uses something else. I'd
>> prefer to do the same thing with ebtables. Does that sound ok to you?
> 
> That sounds wrong to me. Chroots building software may have fewer
> directories than the Makefiles expect, so it's best not to install
> too few files. Deleting files in buildscripts is easier on the mind
> than postinstalling them.

I don't want to install these files on a non-sysvinit system. Enabling
the copying when DESTDIR exists and differs from / is OK for me.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
