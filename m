From: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU
Date: Wed, 15 Apr 2009 00:51:59 +0800
Message-ID: <b6a2187b0904140951r3c6a41fdnc26b149202bdfa84@mail.gmail.com>
References: <20090411174801.GG6822@linux.vnet.ibm.com>
	 <18913.53699.544083.320542@cargo.ozlabs.ibm.com>
	 <20090412173108.GO6822@linux.vnet.ibm.com>
	 <20090412.181330.23529546.davem@davemloft.net>
	 <20090413040413.GQ6822@linux.vnet.ibm.com>
	 <20090413095309.631cf395@nehalam> <49E48136.5060700@trash.net>
	 <49E49C65.8060808@cosmosbay.com> <20090414074554.7fa73e2f@nehalam>
	 <49E4B0A5.70404@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	Patrick McHardy <kaber@trash.net>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>, paulus@samba.org,
	mingo@elte.hu, torvalds@linux-foundation.org, laijs@cn.fujitsu.com,
	jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	benh@kernel.crashing.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <49E4B0A5.70404@cosmosbay.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Apr 14, 2009 at 11:49 PM, Eric Dumazet <dada1@cosmosbay.com> wr=
ote:
> Stephen Hemminger a =E9crit :
>> On Tue, 14 Apr 2009 16:23:33 +0200
>> Eric Dumazet <dada1@cosmosbay.com> wrote:
>>
>>> Patrick McHardy a =E9crit :
>>>> Stephen Hemminger wrote:
>>>>> This is an alternative version of ip/ip6/arp tables locking using
>>>>> per-cpu locks. =A0This avoids the overhead of synchronize_net() d=
uring
>>>>> update but still removes the expensive rwlock in earlier versions=
=2E

Tested. Loaded as fast as 2.6.29.

> Here is an updated patch ontop of yours, with the smp_wmb() in xt_rep=
lace_table() :

Tested as well. Loaded as fast as 2.6.29.

Thanks,
Jeff.
