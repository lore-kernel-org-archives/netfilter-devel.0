From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Wed, 20 Jun 2018 00:22:05 +0200
Message-ID: <161558ff-2002-ae17-d45a-58464b9f8619@iogearbox.net>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <20180614.101831.465275975690050595.davem@davemloft.net>
 <20180615061740.eqgr2iv722oydheb@gauss3.secunet.de>
 <8fd4ce02-6bf0-6bee-f8de-92c551881465@iogearbox.net>
 <20180617092304.fviy36bvgnhexwtb@gauss3.secunet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617092304.fviy36bvgnhexwtb@gauss3.secunet.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 06/17/2018 11:23 AM, Steffen Klassert wrote:
[...]
>> Would be curious about
>> the numbers. You'd get implicit batching for the forwarding via devmap
>> as well if you're required to flush it out via different device with
>> XDP_REDIRECT; otherwise XDP_TX of course. Given we have recently
>> integrated helpers for XDP to do a FIB and neighbor lookup from the
>> kernel tables, where it's thus shared and integrated with the rest of
>> the stack and tooling, it would be awesome to get to the same point
>> with xfrm as well. Eyal recently did a start on that for xfrm for tc
>> progs; would be nice to have integration on XDP as well, potentially
>> it might also result in a bigger plus on the forwarding numbers.
> 
> It might make sense to intrgrate XDP with xfrm to
> be able to compare numbers etc. But I need a working
> XDP setup and some understanding about it first, what
> could take some time.

Okay, no prob. If you have any questions feel free to shoot an email.

Thanks,
Daniel
