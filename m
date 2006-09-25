From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: ip_conntrack_tuple and marks
Date: Mon, 25 Sep 2006 16:04:53 +0200
Message-ID: <4517E205.8090807@gmx.net>
References: <451448A9.6000407@gmx.net>
	<4515F7F8.9030000@netfilter.org>	<4516C70A.3050502@gmx.net>
	<451700B1.7070103@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <451700B1.7070103@rtij.nl>
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

Martijn Lievaart wrote:
> Carl-Daniel Hailfinger wrote:
> 
>> Pablo Neira Ayuso wrote:
>>  
>>
>>> Carl-Daniel Hailfinger wrote:
>>>   
>>>> is it possible to add a nfmark field to ip_conntrack_tuple
>>>> so that only packets with a certain mark set are matched to
>>>> a connection? I'm trying to filter/nat multiple independent
>>>> connections with same ip/proto/port tuples on both sides
>>>> and the only distinguishing property of the different
>>>> connections is their nfmark. Using NOTRACK doesn't help
>>>> because it can only exclude packets from tracking, not
>>>> match packets to different expectations.
>>>>     
>>> Could the connmark match/target be what you need?
>>>   
>>
>> Unfortunately, connmark does exactly the opposite of what
>> I'm trying to achieve.
>>
>> connmark: get/set fwmark based on flow
>> my problem: handle different flows with identical
>>  srcip/dstip/sport/dport/proto tuples where the only
>>  difference is the packet fwmark
>>
>> Example (what I hope to get working)
>> SYN packet from 10.0.0.1:1024->10.0.0.2:80 fwmark 1 creates
>> one connection.
>> SYN packet from 10.0.0.1:1024->10.0.0.2:80 fwmark 2 creates
>> another connection independent of the first. Current netfilter
>> code considers both packets to belong to the same connection.
> 
> Because they are the same connection!

No, they are not. Let me explain:
The box in question has two pairs of interfaces.
eth0: 10.0.0.254/24   eth1: 10.0.1.254/24
eth2: 10.0.0.254/24   eth3: 10.0.1.254/24
I want to do routing and firewalling between eth0 and eth1. That's
simple. However, I also want to do routing and filtering between
eth2 and eth3. Although eth0 and eth2 have the same subnet, they
are NOT the same network, they just happen to have identical
configurations. Same goes for eth1 and eth3.

/\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
\              /    |      |   \              /
 | 10.0.0.0/24 |---eth0  eth1---| 10.0.1.0/24 |
/              \    |      |   /              \
\/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/


/\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
\              /    |      |   \              /
 | 10.0.0.0/24 |---eth2  eth3---| 10.0.1.0/24 |
/              \    |      |   /              \
\/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/

> What on earth are you trying to achieve?

See above. The setup I have usually requires two machines. With
iproute2, it is possible to have eth[0123] in one machine.
Works perfectly and is already in service *as a router*. Loading
netfilter makes this setup very unreliable. I want to fix that.

> What strange setup do you have where these packets do
> *not* belong to the same connection?

You are right that the setup is very strange. Historical baggage :-(
Basically, years ago someone tried to be clever and created two
networks with identical configuration "to reduce management overhead".
I have to deal with the fallout now. Thankfully, the networks do
not have to interoperate yet. That will give me another headache.

> Mind you, that's not only netfilter, the
> recieving box will also see these packets as belonging to the same
> connection.

Since the networks are separate, the receiving boxes are also
separate and thus each of them will only see one of the packets
and only one connection.

Regards,
Carl-Daniel
