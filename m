From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 18 May 2005 08:24:30 +0100
Message-ID: <428AEDAE.3040406@ufomechanic.net>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>	<4278B23A.7050406@trash.net>	<4278B98E.7090707@ufomechanic.net>	<427B8A46.8090006@trash.net>	<427D26E7.8060701@ingate.com>
	<427D3EAF.3020200@trash.net>	<427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net> <428A5141.20901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <428A5141.20901@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

>Amin Azez wrote:
>  
>
>>KOVACS Krisztian wrote:
>>
>>    
>>
>>>  Probably Patrick was referring to a possible problem where the
>>>following happens: a new connection is established and destroyed in a
>>>very short time. If a new connection with the same tuple is created
>>>before the timestamp increases (which is perfectly possible IMHO if you
>>>have some slow embedded HW with no high precision timer available) 
>>>      
>>>
>
>Exactly.
>
>  
>
>>After further reading I think this scenario is highly unlikely.
>>    
>>
>
>Unlikely is still enough reason to handle it properly in an API.
>  
>
By unlikely I didn't mean it would rarely happen I meant the hardware 
with which it could ever happen is surely unlikely. (A different order 
of unlikiness) However I guess your comment below still holds.

>Otherwise anything you build on top of it has to take this into
>account for any guarantees it would like to give. And so far, I
>haven't even seen a suggestion how to notice it - which would
>also be fine with me.
>  
>
One such suggestion is: IFF the conntrack is to be destroyed in the same 
clock tick as it was created, to instead destroy the conntrack one clock 
tick later through death-by-timeout. Then the new conntrack would have 
to be created (although the same clock tick) with a different internal 
conntrack id.
The costs of this would only be borne when such unusual hardware was in 
use, and when the problem case came up, but the internal conntrack id 
could then be used in conjunction with the timestamp to form a unique 
qualifier that (takes deep breath) could be used with the tuple to 
recognize a specific conntrack instance. It would require no extra 
storage but increase the amount of data sent though the netlink socket.

This would still offer some slight benefit over a public conntrack 
serial number in that it would also allow conntrack creation time 
matching in iptables rules.

I do point out and wonder about the possibilities of a denial of service 
though queueing lots of conntracks to be destroyed by timeout 1 tick 
later but think this is hardly any worse than without a timeout in practice.

Another hacky "policy" fix would be to drop the SYN packet that would 
re-create the conntrack in the same tick as its original creation and 
let it be sent again. Its barely normal behaviour to do such a thing, 
such packets deserve to be dropped (for the sins of their parents? Hmm) 
Would such packets get re-sent via a loopback interface? But then again 
device that abuses themselves in such a way beyond the resolution of 
their own timers are surely on drugs?

Amin
