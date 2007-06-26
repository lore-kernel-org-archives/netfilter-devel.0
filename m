From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] early_drop() imrovement (v3)
Date: Tue, 26 Jun 2007 15:27:30 +0200
Message-ID: <46811442.5070308@trash.net>
References: <4615FE1D.80206@sw.ru> <20070406102433.d3a670a5.dada1@cosmosbay.com> <4616203A.80203@sw.ru> <4616626C.9020100@trash.net> <4617845F.7080203@sw.ru> <461789CF.8000106@cosmosbay.com> <46187770.1070106@sw.ru> <46417137.5080501@sw.ru> <467FC8D2.5070102@trash.net> <46811292.1010501@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	devel@openvz.org
To: Vasily Averin <vvs@sw.ru>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757465AbXFZN2i@vger.kernel.org>
In-Reply-To: <46811292.1010501@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Vasily Averin wrote:
> Patrick McHardy wrote:
>> I don't like the NF_CT_PER_BUCKET constant. First of all, each
>> conntrack is hashed twice, so its really only 1/2 of the average
>> conntracks per bucket. Secondly, its only a default and many
>> people use nf_conntrack_max = nf_conntrack_htable_size / 2, so
>> using this constant for early_drop seems wrong.
>>     
>> Perhaps make it 2 * nf_conntrack_max / nf_conntrack_htable_size
>> or even add a nf_conntrack_eviction_range sysctl.
>>     
>
> IMHO The number of conntracks checked in early_drop() have following restrictions:
> - it should be not too low -- to decrease chances of transmission failures,
> - it should be limited by some reasonable value -- to prevent long check delays.

Agreed.

> Also I believe it makes sense to have it constant (how about NF_CT_EVICTION
> name?) -- to have the same behaviour on various nodes. However I doubt strongly
> that anybody will want to change this value. Do you think it is really required?
>   

I don't know. The current behaviour will on average scan 16 entries.
For people manually tuning their hash to saner settings it will scan
a single entry. So we have a quite wide range of values already.
The single entry with sane hash settings is too little IMO, maybe use
some middle-ground, make it 8 by default as you did and rename the
constant. NF_CT_EVICTION_RANGE sounds fine.
