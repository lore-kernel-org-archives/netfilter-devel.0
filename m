From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: uisng L7 filter in ebtables commands
Date: Thu, 01 Apr 2010 12:20:46 +0200
Message-ID: <4BB4737E.7000602@pandora.be>
References: <x2v861e3bca1003311124sa0aa2ab6y94fa42c650ef16f8@mail.gmail.com>	 <4BB4427A.3020706@pandora.be>	 <n2z861e3bca1004010050j7063cee8ya8c27ac73458b8bf@mail.gmail.com>	 <alpine.LSU.2.01.1004010958390.18225@obet.zrqbmnf.qr> <z2t861e3bca1004010248z4bbaf9b7ld414baa09a4153ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: agashi shipora <gashipo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:48348 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0DAKUt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:20:49 -0400
In-Reply-To: <z2t861e3bca1004010248z4bbaf9b7ld414baa09a4153ff@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

agashi shipora wrote:
> Hi ,
>
> The customizations in the linux kernel are provided as binary
> modules(libraries) hence making CONFIG_BRIDGE_NETFILTER work is been
> ruled out.  Thats why I am looking for L7 filter support directly by
> ebtables.
>
>   
What you're asking for isn't going to be included in the standard Linux
distribution. So you'll either have to make the modifications yourself
or pay someone else to do them for you. Feel free to contact me if the
latter case applies.

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

