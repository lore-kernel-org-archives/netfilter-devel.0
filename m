From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Sat, 22 May 2004 16:57:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AF6A60.70406@trash.net>
References: <Pine.LNX.4.33.0405211416341.8045-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405211416341.8045-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> Hm. Actually, as we already use a bit in nfcache for TRACE, we could
> reserve bits generally:
> 
> #define NFC_HOOKS_MASK			0x0000FFFF
> #define NFC_FLAGS_MASK			0xFFFF0000
> 
> /* Special netfilter flags */
> 
> #define NFC_PKT_FLAGS_MASK		0x00FF0000
> #define NFC_CT_FLAGS_MASK		0xFF000000
> 
> #define NFC_FLAG_TRACE			0x00010000
> #define NFC_FLAG_NOTRACK		0x00020000
> #define NFC_FLAG_CT_TCP_SYNRST		0x01000000
> 
> The lower half could be manipulated by MARK while the upper half by
> CONNMARK. But the latter would require a new element in ip_conntrack
> itself and I wouldn' really like to make it bigger.

I like the idea for MARK, but why should we manipulate nfcache from
CONNMARK, and not let the users of the bits get them directly from
struct ip_conntrack (f.i. CT_TCP_SYNRST).

> Do we really need an unsigned long to store the status? :-)

I always thought we would, because set_bit and test_bit take unsigned
long *, but I'm not sure anymore if that really means we can't use
something smaller.

But good news, I'm currently busy shrinking struct ip_conntrack (I bet
myself I could shrink it 30% within 24 hours). I'm already at 28% ;)

-8bytes replacing struct ip_nat_hash by struct list_head because of two
saved conntrack pointers
-20bytes replacing struct nf_ct_info array by new value in struct
sk_buff indicating relation between skb and conntrack .. maybe we could
also put this in nfcache.
-56bytes dynamically allocating helper data, but crashes with NAT atm

I see 4 more bytes by using u_int16_t for initialized and num_manips in
struct ip_nat_info, and maybe I can also squeeze masq_index in there.

> 
> 
>>PS: Joszef, I changed your address to @netfilter.org, your mailserver
>>doesn't like me.
> 
> 
> I whitelisted you, sorry for the inconvenience.

Thanks.

Regards
Patrick
