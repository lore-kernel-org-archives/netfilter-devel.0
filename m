From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH 0/10]: ct_extend
Date: Tue, 26 Jun 2007 01:49:02 +0900 (JST)
Message-ID: <200706251649.l5PGn3h0001827@toshiba.co.jp>
References: <200706250314.l5P3E2M4008231@toshiba.co.jp>
	<467F9603.2070005@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, yasuyuki.kozakai@toshiba.co.jp,
	kadlec@blackhole.kfki.hu
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467F9603.2070005@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 25 Jun 2007 12:16:35 +0200

> Yasuyuki KOZAKAI wrote:
> > Hi,
> > 
> > This patch set is a snapshot of the ct_extend, which shrinks memory
> > usage where extensions such as NAT and helper are not used.
> > 
> > I've applied all suggestions from Patrick. If nat module is loaded,
> > ct_extend pre-allocates extended area of NAT when it initially allocates
> > extended area of helper. I've also renamed functions to nf_ct_ext_* and
> > merged the members in 'struct nf_nat_info' into 'struct nf_conn_nat'.
> 
> 
> The patches look pretty good to me. For normal conntracks without
> NAT or helpers its a clear win since we avoid the double search of
> expectations. The only case I'm a bit worried about is NAT, for that
> case we get an extra allocation for every new connection. But I
> guess thats better than what we have now, the double search reportedly
> costs about 10% performance for all cases.
> 
> Do you think we should put these patches in 2.6.23?

I think it's ready.

I've re-checked race at nf_conntrack_netlink and I think there is no
race on members in nfct_nat(ct) at ct_netlink_change_helper(). Because

- 'bysource' and 'ct' are protected by nf_nat_lock when the area of
  nfct_nat(ct) is reallocated.
- 'seq' and 'help' are used by only helper, but we don't change helper.
  So there is no race.
- 'masq_index' is set in ipt_MASQUERADE.c while conntrack is
  unconfirmed. Besides nfctnetlink can change only confirmed conntracks.
  And 'masq_index' in confirmed conntrack is never changed.

BTW, I don't understand why ipt_MQASQUERADE needs lock. I think there is no
difference of results if we remove the lock. If we want to completely
discards conntracks related to output device, MASQUERADE should wait
in *_event() until all packets pass through network stack. But I'm not sure
it's possible.


Anyway, I'll resend updated patches.

-- Yasuyuki Kozakai
