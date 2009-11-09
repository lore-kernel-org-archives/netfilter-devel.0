From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Mon, 09 Nov 2009 14:09:38 +0100
Message-ID: <4AF81492.7040604@trash.net>
References: <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr> <20091101130739.GC11601@piche.inl.fr> <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr> <20091101.222249.93035620.davem@davemloft.net> <alpine.LSU.2.00.0911031759340.24979@obet.zrqbmnf.qr> <20091106200907.GB3089@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Pierre Chifflier <pchifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39109 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZKINJh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2009 08:09:37 -0500
In-Reply-To: <20091106200907.GB3089@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre Chifflier wrote:
> I am not very familiar with these kind of problems (alignment). If I
> understand correctly, what I need to avoid is playing with pointers on a
> buffer, especially if trying to read a structure.
> 
> Since what I am trying to read is formatted as following:
> 
> marker (uint32)
> total_size (uint16)
> payload_length (uint16)
> payload (struct iphdr)

This looks fine. Your input buffer should be suitably aligned
by the allocator and these members are all well-aligned
themselves.

> Followed by a sequence of
> option_id (uint16)
> option_length (uint16)
> option_value (variable, equal to option_length)

> Am I right to assume that:
> - I can define a (packed) structure for the first part, and that I can
>   set the pointer on the data buffer which was allocated by malloc
>   without problems ? [*]

You don't even need packing.

> - For the second part, there are 2 cases:
>   + integers must be read byte per byte
>   + strings can be used directly ?

Assuming integers do not exceed 32 bit, just make sure the entire
sequence is aligned to a multiple of four (which it is for the
first entry, further ones need to use padding).
