From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/10]: ct_extend
Date: Mon, 25 Jun 2007 20:05:37 +0200
Message-ID: <468003F1.8050409@trash.net>
References: <200706250314.l5P3E2M4008231@toshiba.co.jp>	<467F9603.2070005@trash.net>
	<200706251649.l5PGn3eL021623@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251649.l5PGn3eL021623@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Mon, 25 Jun 2007 12:16:35 +0200
> 
>>Do you think we should put these patches in 2.6.23?
> 
> 
> I think it's ready.

Great.

> I've re-checked race at nf_conntrack_netlink and I think there is no
> race on members in nfct_nat(ct) at ct_netlink_change_helper(). Because
> 
> - 'bysource' and 'ct' are protected by nf_nat_lock when the area of
>   nfct_nat(ct) is reallocated.
> - 'seq' and 'help' are used by only helper, but we don't change helper.
>   So there is no race.
> - 'masq_index' is set in ipt_MASQUERADE.c while conntrack is
>   unconfirmed. Besides nfctnetlink can change only confirmed conntracks.
>   And 'masq_index' in confirmed conntrack is never changed.

Sounds right.

> BTW, I don't understand why ipt_MQASQUERADE needs lock. I think there is no
> difference of results if we remove the lock. If we want to completely
> discards conntracks related to output device, MASQUERADE should wait
> in *_event() until all packets pass through network stack. But I'm not sure
> it's possible.


Yes it looks unnecessary. Reliably removing all conntracks is not
really necessary, its only an optimization to keep the table smaller.

I'm actually happy about every missed connection since my DSL line
has an almost permanent address and connections usually live on
after a reconnect unless NAT remaps them :)
