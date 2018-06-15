From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 06:01:26 -0700
Message-ID: <cbd4a882-8d7a-2465-3e3f-5d3212ac4b5e@gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <70e4a28c-ccc3-6fd5-0d43-08ae72b7ad1b@gmail.com>
 <20180615060307.fwwc2vnb5rpc464p@gauss3.secunet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180615060307.fwwc2vnb5rpc464p@gauss3.secunet.de>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 06/14/2018 11:03 PM, Steffen Klassert wrote:
> On Thu, Jun 14, 2018 at 08:57:20AM -0700, Eric Dumazet wrote:
>>

>> Saving cpu cycles on moderate load is not okay if added complexity
>> slows down the DDOS (or stress) by 10 % :/
> 
> Why 10%?
> 

GRO adds a ~6 % cost on UDP receive path at this moment, depending on the state
of GRO engine (number of packets in the napi->gro_list)

Adding yet another conditions and icache pressure might raise the cost to 10%,
but we do not know because the numbers presented in this RFC do not include that.

(Early demux is also adding extra costs for UDP on 'non connected sockets' BTW)

Most linux hosts are not routers, but end hosts, lets not forget this...
