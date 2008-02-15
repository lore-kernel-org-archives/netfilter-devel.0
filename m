From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCHv4 2/5] Adds AF_BRIDGE and ARP header interpreter to  
    BASE plugin
Date: Fri, 15 Feb 2008 18:39:50 +0100
Message-ID: <47B5CE66.4090107@endian.com>
References: <20080211220753.796791654@endian.com>    <20080211221056.242019648@endian.com> <47B377A2.6080309@endian.com> <4279.80.214.249.17.1202974766.squirrel@mail.inl.fr> <47B42760.5080603@endian.com> <47B45D0F.8070008@netfilter.org> <47B5CB03.2070903@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:52127 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242AbYBORkD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:40:03 -0500
In-Reply-To: <47B5CB03.2070903@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys

Peter Warasin wrote:
> I changed to ui32, since ip_addr is ui32, but the arp ip fields
> are ui8[4].
> I think ui32 should be correct with the casts now.

I was to fast posting the patch. Sorry
The patch does not work anymore for me.
I will debug it and resent it later.

peter

