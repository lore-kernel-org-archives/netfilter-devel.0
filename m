From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Fri, 6 Nov 2009 21:09:07 +0100
Message-ID: <20091106200907.GB3089@piche.inl.fr>
References: <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr>
 <20091101130739.GC11601@piche.inl.fr>
 <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr>
 <20091101.222249.93035620.davem@davemloft.net>
 <alpine.LSU.2.00.0911031759340.24979@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, pchifflier@edenwall.com,
	netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44631 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbZKFUJO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:09:14 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911031759340.24979@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 03, 2009 at 06:01:46PM +0100, Jan Engelhardt wrote:
> >
> >If GCC can see at the inlining point that 'ptr' is of a type that
> >should be properly aligned it can inline the memcpy and still emit
> >the very unaligned load or store that you're trying to avoid.
> 
> Hi Dave,
> 
> Indeed it seems to be this way. Hm, bad.
> 
> What codes are you using on your alignment-sensitive SPARCs -
> the standard bitshifting, "char *p; p[0]<<24 | p[1]<<16 | p[2]<<8 | p[3]"?

Hi all,

I am not very familiar with these kind of problems (alignment). If I
understand correctly, what I need to avoid is playing with pointers on a
buffer, especially if trying to read a structure.

Since what I am trying to read is formatted as following:

marker (uint32)
total_size (uint16)
payload_length (uint16)
payload (struct iphdr)

Followed by a sequence of
option_id (uint16)
option_length (uint16)
option_value (variable, equal to option_length)

Am I right to assume that:
- I can define a (packed) structure for the first part, and that I can
  set the pointer on the data buffer which was allocated by malloc
  without problems ? [*]
- For the second part, there are 2 cases:
  + integers must be read byte per byte
  + strings can be used directly ?

[*] none of the iphdr, ip or similar structures are defined as packed in
netinet/ip.h

Thanks,
Pierre

