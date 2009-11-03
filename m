From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Tue, 3 Nov 2009 18:01:46 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911031759340.24979@obet.zrqbmnf.qr>
References: <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr> <20091101130739.GC11601@piche.inl.fr> <alpine.LSU.2.00.0911011432160.26262@obet.zrqbmnf.qr> <20091101.222249.93035620.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pchifflier@edenwall.com, netfilter-devel@vger.kernel.org,
	eleblond@inl.fr
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41993 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZKCRBl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:01:41 -0500
In-Reply-To: <20091101.222249.93035620.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-11-02 07:22, David Miller wrote:
>> +static inline uint32_t deref_get_32(const void *ptr)
>> +{
>> +       uint32_t ret;
>> +       memcpy(&ret, ptr, sizeof(ret));
>> +       return ret;
>> +}
>> 
>> Is what I use in one project; however, trying to minimize the
>> unalignedness - iptables is a "perfect" example, and netlink
>> may do the same tho I am not sure - seems to be the best
>> approach in serialized streams.
>
>This will not work all the time.
>
>If GCC can see at the inlining point that 'ptr' is of a type that
>should be properly aligned it can inline the memcpy and still emit
>the very unaligned load or store that you're trying to avoid.

Hi Dave,

Indeed it seems to be this way. Hm, bad.

What codes are you using on your alignment-sensitive SPARCs -
the standard bitshifting, "char *p; p[0]<<24 | p[1]<<16 | p[2]<<8 | p[3]"?
