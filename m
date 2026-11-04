Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793792541;
	b=S5ywK5lp/q9qJvR4kd1/SU7uxLnSkwGCz/xUjYfhKvpimn/pL+Kdz1duAPkVb/ACITRZ
	 vRBjAKt8t0W6+nUXRATMA34rFyarT6++hl/i4rBwGY1z1FIWHGR32lucX7TQ15CkGS7Ng
	 e+ae3daSHiPzdlNt7L4ye9Fs1b+QHR1Xn7YbnKcFFkQ0iolKCHLo+UVKaQtleA6XoWQ/D
	 coWqtLMhKsK49CS5xETkfuSVfE0Xgi+2bL11F9pc2efVs04WpUb1Ovog1sATSly745kHp
	 QE6qEJC6K/LACGShN+HZ160Y98loGhBm/kGsGRnRNrf+T0ZDGUlsuB4QJsxS9SnMkPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793792541;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=D5UEf4Kw0Bb3Mtn0doCb3H9WcV9PIrFjslUwc2RO04Y=;
	b=Sj/pTCvNbl5S9bpyBdfzTSjzo97zRf8H3yfaBsvE31+pjnxsb2BmkU2k3sA/lSyJxa7r
	 1MCDLk4DGkD3i/YhCk6M2NOjKRZjxVFsqsN5WWvcojB06xJEB0QguzaYcGd0dsNpg6vbt
	 oRtYBkht23AXNqDuie1qRQnZMVZxX6184nMqbK6yFTnJHiBogf0KkG7N2DlaX4xltUb/k
	 wWruL+iNLxcjf+eUI+woQCqBi35hGnsZ+pwM2AAh1OjAz4xKZoxcUmxuf/6O1yI05ZSDP
	 rZhu0eJpW5/ukHOpTipKTy3P0bHniOBfypRWBmFEsEJHZhD3FT4Fhdph1BSq89+LsPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VOOQQb3a;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D8853606A326;
	Wed,  4 Nov 2026 11:42:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8853606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VOOQQb3a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793792538;
	bh=D5UEf4Kw0Bb3Mtn0doCb3H9WcV9PIrFjslUwc2RO04Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VOOQQb3aQKUnG5gMkSe9fPtzk6DslIEZeWbQXi32J8dkTEGJmTSDelZMSa5MQes2F
	 Km5x462pEFfSHRRwkpK6mZF26ZoZw/ndbS4/+E0HoCVTBGrFPz2oa7nq+I18U9wM44
	 2Xkkd3Qpq6APUzt25WOPGJXrCYnIrgolBNDkibREioCTyzlUAMCjGGdN/KkdFt4KPy
	 GzQHyJBHm7PgbabDICeCBpM+msZwqigouoImmq/mSguoCZ8MbACSBo5xL5/zNdzd8r
	 hwgVgyTbvHDilYzF3Oz6klk8lBIrN7MNKub+Z1tB2+Pbv/2S9KdcxHhVZgV0uKXs/A
	 mb3MCypV3t/ew==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1750460055;
	Wed,  4 Nov 2026 12:42:18 +0100 (CET)
Date: Wed, 4 Nov 2026 12:42:15 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?Sm/Do28=?= Silva <jgc3silva@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sven Auhagen <sven.auhagen@voleatech.de>,
	Oz Shlomo <ozsh@nvidia.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: do not clear the offload bit
 twice
Message-ID: <ausaF4X_RieUIjxg@chamomile>
References: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
 <aunoySCHzqwI1QIz@chamomile>
 <f909ccfb-0bad-4ad2-a5d7-d836f4bbc958@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f909ccfb-0bad-4ad2-a5d7-d836f4bbc958@gmail.com>

On Tue, Nov 03, 2026 at 06:56:30PM +0000, João Silva wrote:
> Hi,
> 
> The fix was LLM generated but I wouldn't say it's just "for correctness".
> For some context, this issue was hit while developing hardware-offloaded
> flows for the RTL930x target in openwrt. There was a point in development
> where this was causing flows to pile up and eventually exhaust the TCAM of
> the PIE engine on the switch.

Good, but that is not an out-tree driver?

If so, this should follow nf-next.

Thanks

> Thanks for considering.
> 
> João Silva
> 
> 
> On 03/11/26 13:59, Pablo Neira Ayuso wrote:
> > On Tue, Nov 03, 2026 at 09:52:56AM +0000, João Silva via B4 Relay wrote:
> > > From: João Silva <jgc3silva@gmail.com>
> > > 
> > > An expired hardware flow remains in the flowtable until its asynchronous
> > > hardware deletion completes. Teardown clears IPS_OFFLOAD_BIT, so a packet
> > > can create a replacement flow referencing the same conntrack entry while
> > > the old flow is still waiting for deletion.
> > > 
> > > The next GC pass calls flow_offload_teardown() on the expired old flow
> > > again, clearing the replacement's offload bit. More packets can then
> > > create additional flows for the same conntrack entry. A pending hardware
> > > work item can also delay deletion and expose the same repeated teardown.
> > > 
> > > Commit d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of
> > > offload bit") closed this window for software flows by unlinking them in
> > > the same GC pass and made the conntrack state fixup one-shot, but
> > > hardware flows stay linked until NF_FLOW_HW_DEAD is set.
> > > 
> > > Make clearing IPS_OFFLOAD_BIT part of the existing one-time teardown
> > > transition, alongside the conntrack state fixup. Subsequent teardown calls
> > > must not alter the offload state now owned by a replacement flow.
> > Let's better target nf-next for this, this looks like LLM triggered
> > for correctness.
> > 
> > Thanks.
> > 
> > > Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
> > > Signed-off-by: João Silva <jgc3silva@gmail.com>
> > > ---
> > >   net/netfilter/nf_flow_table_core.c | 6 ++++--
> > >   1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > index 0d72dc8ae47a..709b55b74cc7 100644
> > > --- a/net/netfilter/nf_flow_table_core.c
> > > +++ b/net/netfilter/nf_flow_table_core.c
> > > @@ -398,9 +398,11 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
> > >   void flow_offload_teardown(struct flow_offload *flow)
> > >   {
> > > +	if (test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
> > > +		return;
> > > +
> > >   	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> > > -	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
> > > -		flow_offload_fixup_ct(flow);
> > > +	flow_offload_fixup_ct(flow);
> > >   }
> > >   EXPORT_SYMBOL_GPL(flow_offload_teardown);
> > > 
> > > ---
> > > base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
> > > change-id: 20261103-flowtable-offload-bit-f15bfd1d38ed
> > > 
> > > Best regards,
> > > -- 
> > > João Silva <jgc3silva@gmail.com>
> > > 
> > > 
> 
