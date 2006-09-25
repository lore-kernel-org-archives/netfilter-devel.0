From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Proposal] ip_conntrack_tuple extension for advanced matching
Date: Tue, 26 Sep 2006 01:48:19 +0200
Message-ID: <45186AC3.6080505@netfilter.org>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>	<4517E205.8090807@gmx.net>
	<45182332.8090303@rtij.nl> <45184198.1060906@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <45184198.1060906@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Martijn Lievaart wrote:
>> Carl-Daniel Hailfinger wrote:
>>
>>> No, they are not. Let me explain:
>>> The box in question has two pairs of interfaces.
>>> eth0: 10.0.0.254/24   eth1: 10.0.1.254/24
>>> eth2: 10.0.0.254/24   eth3: 10.0.1.254/24
>>> I want to do routing and firewalling between eth0 and eth1. That's
>>> simple. However, I also want to do routing and filtering between
>>> eth2 and eth3. Although eth0 and eth2 have the same subnet, they
>>> are NOT the same network, they just happen to have identical
>>> configurations. Same goes for eth1 and eth3.
>> OK, it's clear to me now. I don't think you can achieve that with
>> current netfilter connection tracking.
> 
> Yes, that's why I wanted to change conntack to optionally consider
> a fwmark/whatever value for matching connections.
> 
> 
>>> /\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
>>> \              /    |      |   \              /
>>> | 10.0.0.0/24 |---eth0  eth1---| 10.0.1.0/24 |
>>> /              \    |      |   /              \
>>> \/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/
>>>
>>>
>>> /\/\/\/\/\/\/\/\    +------+   /\/\/\/\/\/\/\/\
>>> \              /    |      |   \              /
>>> | 10.0.0.0/24 |---eth2  eth3---| 10.0.1.0/24 |
>>> /              \    |      |   /              \
>>> \/\/\/\/\/\/\/\/    +------+   \/\/\/\/\/\/\/\/
>> Why not do it exactly like that, but with two real boxes? Makes
>> interconnecting later also a nobrainer (NETMAP).
> 
> The setup is already running with one box. It's just the firewalling
> which has problems sometimes. I've even used NETMAP to make
> connections between the networks of eth0 and eth2 possible on the
> same machine.
> The problems only happen if two connections with the same conntrack
> tuple happen at the same time. A seldom occurence, I agree. But I
> had it happen (IIRC there were two identical pings running in the
> different network pairs). Now my goal is to make it perfect.
> 
> 
> New proposal:
> To handle interfaces in different networks with identical configuration,
> connection tracking may optionally consider an additional "realm/mark"
> value for matching connections. Such a value would be set for each
> packet in the RAW table and have a default value of 0. For existing
> setups, no change will happen. Both directions of a flow must have the
> same "realm/mark" value set on incoming packets. Expectations also will
> have the value set for any new expectation. Since reusing nfmark will
> break some setups, struct sk_buff probably has to be enlarged.
> 
> Would a patch for adding such a feature be accepted into mainline?

IHMO, your numering schema is not convenient. I would not accept such
patch since I can't see any other utility apart from supporting your
setting.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
