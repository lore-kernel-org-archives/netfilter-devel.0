From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ebtables-2.0.9-2: build fixes
Date: Tue, 16 Mar 2010 14:12:47 +0100
Message-ID: <4B9F83CF.4090506@pandora.be>
References: <1268725978.19121.3.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:44112 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0CPNMu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:12:50 -0400
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
I also applied the DESTDIR addition.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

