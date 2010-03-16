From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: arptables 0.0.3-4 build fixes
Date: Tue, 16 Mar 2010 14:16:09 +0100
Message-ID: <4B9F8499.1060104@pandora.be>
References: <alpine.LSU.2.01.1003161144290.27631@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:46005 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937496Ab0CPNQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:16:12 -0400
In-Reply-To: <alpine.LSU.2.01.1003161144290.27631@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> 
> from my side two build patches for arptables.
> 
> (1) Do not call install with -o or -g, because it makes unprivileged 
> installs (used by build chroots) fail. Autotools does not use -o or -g 
> either, so the usage is consistent and does what was inteded when root
> is running `make install`.
> 
> (2) Fixing all the compiler warnings that turned up about printf 
> formatting and strict-aliasing.
> 

Hi,

Someone once insisted using this -o -g usage long ago and no
distributors have complained about it yet, so I'm going to leave it in
for now. Plenty of other projects do it this way too.

The warings that occur when using llu with 64-bit numbers should be
resolved with the PRIu64 macro. Could you fix that and resubmit, please?
Thanks.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
