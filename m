Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795303433;
	b=CJer7Vo6w+cVO3mjimKaGkxqq24FbzVG8xTRqLoUXy4gOEwK5LpCl/3ogG0TOcWLoYoZ
	 jc75E4sdLWHvWS4y4eqvLeYuq1IzinNq046bv07BiVktDGHxGg5k4t/IY+sIdTrVmiKKe
	 NQfEtWV3/bh5NWpt0XsGMdfdEIwzVB2NEZGWV5t0wIQ/gg4mzE+Ya2vtaA0v19215iBdY
	 5HGCo+0A+kDZU918H6lUs46EJ/fphDymkmQExXyOwIQjI1xiIjI0tSYhYKpVP+Y99h+NV
	 QA/zQinI7CC+4pDU29ze+Anb5Nh0f6iSYyr1YEVjHoCMt3bMOPG9mAbB33NLzuYyqgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795303433;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=fiedK0LMLpg949+WbK0ZI33jcOksdkyv7tc4RWl8y2A=;
	b=mZnpf2sJHN/BLHjN8L8Xw5IJHRi0K2okhcg/xrStlttF0zJTU9nD+OMG4olZRtghuR4Q
	 OwV72FFLxrPDXffQ9h9L2lkoyoa6Rl/1DTlysuV/hqrHc91u0UMYVHZ6RVonVB2Et+dK1
	 OXTjZJTR7+JS4eDzZPejGOrHr6z56fBa55HLw3b1A9gU/yOq9Y/gd6a3V+1y1RmXizEFo
	 PWRvlhaCBGF3Ja3QX77eUzOvPeLUqu36uDtOhuNWb16/NLqxaUJ1jZp4eWJAmHi3rLSxJ
	 AVtDlLLjhmyAyVxzQWFEMcD/ohvvv5Pvjp+poAGvYAD+UG/Wmd1nsjMSG6QBO8+FauQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Mjx+VZY6;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EF5C6606A320;
	Sat, 21 Nov 2026 23:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF5C6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Mjx+VZY6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795303430;
	bh=fiedK0LMLpg949+WbK0ZI33jcOksdkyv7tc4RWl8y2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mjx+VZY6SWzg/KaoyDuuSmFdlq4sBo+hlSCL36KiOWf6n2mE/5L9B6niEydtAleOl
	 EsRkJSahZ9cBoBznJ++9fso4zUqu6BZ/iqjMSKsfZKJ1GWhCAoQ5hPy9vEM2UV29wE
	 16ONdISWmn/t6imvu/MYuKesEBeB7+o85WN37KlfeInE7FyGz4m03DjvqkiAe8IdYW
	 9DmMOUDGQDjR5Q7oWjyo9qM8ThXajcpQgc4Z86OSyD1asAKrFyR4VdhvnMK5pXBYml
	 OT30tEid/wmyGpU0rX2a7BLC91sgzqJlnyp1PbpaKW/mqbVBbYyj0LnUDUei+luow8
	 QttcYlDqqSZqQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 82C126005F;
	Sun, 22 Nov 2026 00:23:50 +0100 (CET)
Date: Sun, 22 Nov 2026 00:23:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Toshiaki Makita <toshiaki.makita1@gmail.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH net 1/4] netfilter: flowtable: do not queue offload work
 after DESTROY
Message-ID: <awIoBL3Rz5GbNs1l@chamomile>
References: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
 <20261118201250.2075007-2-florian.fainelli@broadcom.com>
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
In-Reply-To: <20261118201250.2075007-2-florian.fainelli@broadcom.com>

On Wed, Nov 18, 2026 at 12:12:47PM -0800, Florian Fainelli wrote:
> nf_flow_offload_refresh() can be reached by a packet path reader which
> looked the flow up before it was torn down. NF_FLOW_PENDING keeps the
> DESTROY work from being queued while another work item is pending, but
> once the DESTROY work has run and cleared the bit, a reader can take it
> again and queue a REPLACE (or STATS) work for a flow which is already
> being removed.
> 
> GC removes a hardware flow after NF_FLOW_HW_DEAD is set, and frees it after
> an RCU grace period, which the reader can outlive in a preemptible RCU
> read-side section. The queued work then dereferences a freed flow and
> the flowtable, and can program the hardware again with a rule keyed by
> the freed flow's cookie.
> 
> NF_FLOW_HW_DYING is set when DESTROY is queued, and DESTROY needs
> NF_FLOW_PENDING, so a work item which holds the pending bit and finds
> NF_FLOW_HW_DYING clear prevents DESTROY from being queued until it
> completes. Check it after taking the pending bit, and do not queue
> anything other than DESTROY when it is set.
> 
> Not reproduced: this is a race between a long RCU read-side section and
> the GC and offload workers. Found by review of a related change.
> 
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> ---
>  net/netfilter/nf_flow_table_offload.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e6..62f460d38efa 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1088,6 +1088,19 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
>  	if (test_and_set_bit(NF_FLOW_PENDING, &flow->flags))
>  		return NULL;
>  
> +	/* GC only removes a hardware flow after its DESTROY work has run, and
> +	 * NF_FLOW_PENDING keeps another one from being queued, so nothing can
> +	 * free the flow while this work is pending, unless DESTROY was queued
> +	 * before we took the pending bit. A reader which found the flow before
> +	 * it was torn down must not queue more work then, as the flow could be
> +	 * freed before that work runs.
> +	 */
> +	if (cmd != FLOW_CLS_DESTROY &&
> +	    test_bit(NF_FLOW_HW_DYING, &flow->flags)) {
> +		clear_bit(NF_FLOW_PENDING, &flow->flags);
> +		return NULL;
> +	}

Maybe address by checking for the _CLOSING + _TEARDOWN flag? If those
are set on, then hardware will be scheduled for removal soon.

I guess there is also another hypothetical case where _CLOSING is set
on, but HW_DYING was not set on yet?

Probably the HW_DYING bit can go away, _CLOSING was added for hw
offload specifically, to schedule the removal in hardware while the
flow still remains with IPS_OFFLOAD.

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 11434cfb105b..7104d332d98a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1132,7 +1132,8 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
        if (!offload)
                return;
 
-       if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+       if (test_bit(NF_FLOW_CLOSING, &flow->flags) ||
+           test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
                clear_bit(NF_FLOW_PENDING, &flow->flags);
                kfree(offload);
                return

> +
>  	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
>  	if (!offload) {
>  		clear_bit(NF_FLOW_PENDING, &flow->flags);
> -- 
> 2.53.0
> 
> 
