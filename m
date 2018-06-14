From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 08:57:20 -0700
Message-ID: <70e4a28c-ccc3-6fd5-0d43-08ae72b7ad1b@gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, steffen.klassert@secunet.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/14/2018 07:19 AM, Pablo Neira Ayuso wrote:
> Hi,
> 

> We have collected performance numbers:
> 
>         TCP TSO         TCP Fast Forward
>         32.5 Gbps       35.6 Gbps
> 
>         UDP             UDP Fast Forward
>         17.6 Gbps       35.6 Gbps
> 
>         ESP             ESP Fast Forward
>         6 Gbps          7.5 Gbps
> 
> For UDP, this is doubling performance, and we almost achieve line rate
> with one single CPU using the Intel i40e NIC. We got similar numbers
> with the Mellanox ConnectX-4. For TCP, this is slightly improving things
> even if TSO is being defeated given that we need to segment the packet
> chain in software. We would like to explore HW GRO support with hardware
> vendors with this new mode, we think that should improve the TCP numbers
> we are showing above even more.

Hi Pablo

Not very convincing numbers, because it is unclear what traffic patterns were used.

We normally use packets per second to measure a forwarding workload,
and it is not clear if you tried a DDOS, or/and a mix of packets being locally
delivered and packets being forwarded.

Presumably adding cache line misses (to probe for flows) will slow down the things.

I suspect the NIC you use has some kind of bottleneck on sending TSO packets,
or that you hit the issue that GRO might cook suboptimal packets for forwarding workloads
(eg setting frag_list)

This path series add yet more code to GRO engine which is already very fat
to the point many people advocate to turn it off.
Saving cpu cycles on moderate load is not okay if added complexity
slows down the DDOS (or stress) by 10 % :/

To me, GRO is specialized to optimize the non-forwarding case,
so it is counter-intuitive to base a fast forwarding path on top of it.
