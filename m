From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes & 64bit counters
Date: Mon, 15 Jan 2007 15:37:14 +0100
Message-ID: <45AB919A.4030100@trash.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net> <45660CD5.1090405@netfilter.org>
	<4566B6B6.4060808@trash.net>
	<Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
	<45A4EBC8.60304@trash.net>
	<Pine.LNX.4.64.0701151141410.13986@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <olenf@ans.pl>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0701151141410.13986@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> On Wed, 10 Jan 2007, Patrick McHardy wrote:
> 
>>> linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c
>>> 2006-12-22 21:13:35.000000000 +0100
>>> @@ -1148,9 +1148,6 @@
>>>          ct->counters[CTINFO2DIR(ctinfo)].packets++;
>>>          ct->counters[CTINFO2DIR(ctinfo)].bytes +=
>>>                          ntohs(skb->nh.iph->tot_len);
>>> -        if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
>>> -            || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
>>> -            event |= IPCT_COUNTER_FILLING;
>>
>>
>>
>> This was actually broken before, since the counters are not
>> reset (they just overflow) an event was generated for every
>> packet until the overflow once they reached 2^31. Anyway,
>> I'm not sure how ulogd2 uses these counters, Harald, is it
>> necessary to receive period updates?
> 
> 
> If we remove IPCT_COUNTER_FILLING there is no other solution than also
> drop this part of the code.

Let's wait what Harald says about ulogd2, I'm not sure whether we need
to keep this.

> BTW: what about CTA_COUNTERS32_*? Should we also drop that attributes?

They should be kept to make sure the value are not reused. Please just
add a comment stating that they are not used anymore.
