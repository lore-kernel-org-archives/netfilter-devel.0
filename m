Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795302641;
	b=JSaKVbOlgjZkYmuc9DugQ17OhgErYBWNbd04rE+KlvcJi97E8igCTLS9lFtS6kwmkMtL
	 I6t+8YwXy9smVLWcJ5rv3LWeQAyYP2i3Z55qt29XzrwqlOLvcL7yXH1LdRJqI/K81klrJ
	 T4Z9Oji2eb4HEJGuzRT7YU0Sf1n3i4MFxhLuRwZbJarPZOpXh8UKcb9uWuKyFBwC2J72r
	 tvznPT7TvCSWqVOJNOpPmJvlPZ28x9xFD76SK7kvKTkTCqI+LT8iNfN+A0CSsbMHwWWDK
	 ccjdpoQ0OfUIIUAmghHoevf0oW9GXz/Sib3EiUS57uavP2dz4sdB0ypoXFBRvZKzJiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795302641;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=E9/g6o7R3K4v+CNdU1O2I9n3rAKPMOd33E4vaKpYOIc=;
	b=IJTXoVglYtu42cz9eXlICP764G6MjUYKrKuDlbUnycjw1V6kLkGKAHUt3mqwBIKEl8Eg
	 ShYtl+PosAubXPnmlzmQB8H1Pwu8gHNCtOrZfyY/hQDQ2l+ArBuEjrHFknwwR1dv5jx9E
	 RnFnbEpx9mCSg7++NyaaK3cptqA+mf9ygekUTD5695EupT6XOGMIGKPEfUDwn6vVBGMv0
	 zDEEdwr7u/v5ophg0zy/XY6PZeE9a9A4VfSzcvAb8g07z6HSbx4xaEXyME8Dv8DzQATjH
	 Yi+NdnXQ7Xc+l4qxgBgJdbEzCSdEpG8GnQyW7fNYhe3MUO18cc/87VKXSu5N/v5LQqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hgKJt0zK;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F39F7606A320;
	Sat, 21 Nov 2026 23:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F39F7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hgKJt0zK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795302638;
	bh=E9/g6o7R3K4v+CNdU1O2I9n3rAKPMOd33E4vaKpYOIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hgKJt0zK8Ed92EIDgai/GbkljCzw05uxAoLux0phFBmi9iaYcpqV3aQll1LGlEBoC
	 S22xC5ZE2lh8nXS47k2jgw4yLt0VVS3QkURh+GrpLV+94WMthQhhkNtR83hsgevEbD
	 8XxowqhyeOfXtq43MPKG1AxeZ7CnSTADa6ZE5r8zQOVW/nDbj3GY/o1dn+BBJB7crZ
	 hARAbIedqc3kqiqBlLLV2IIEey6kofjASM4H5ZbE0Dt5b1STQIkZIm4ZFZNb3POAar
	 WodswVSvoMbwSK3wOe7CP6KU0KqUF4UASFVwBolnky70t93sbtx77H9nCF8ynefCcX
	 neOYSt4Jlk5Rg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6A32460058;
	Sun, 22 Nov 2026 00:10:38 +0100 (CET)
Date: Sun, 22 Nov 2026 00:10:35 +0100
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
Subject: Re: [PATCH net 2/4] netfilter: flowtable: restore the GRE conntrack
 timeout on teardown
Message-ID: <awIk65mKn6iBATE0@chamomile>
References: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
 <20261118201250.2075007-3-florian.fainelli@broadcom.com>
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
In-Reply-To: <20261118201250.2075007-3-florian.fainelli@broadcom.com>

Hi Florian,

On Wed, Nov 18, 2026 at 12:12:48PM -0800, Florian Fainelli wrote:
> flow_offload_add() sets the timeout of the conntrack entry to NF_CT_DAY
> for every offloaded flow, and the GC keeps extending it for GRE too.
> flow_offload_fixup_ct() only restores the conntrack timeout of TCP and
> UDP flows when the flow is torn down, so an offloaded GRE entry which does
> not see any other packet on the slow path stays for up to a day instead
> of expiring after the GRE conntrack timeout.
> 
> Restore the GRE timeout, replied or unreplied, as for UDP. GRE has no
> offload timeout of its own, flow_offload_get_timeout() uses the default
> flowtable timeout for it, so use that one when the flow expired.

I think GRE has never worked then. I have been a bit skeptical about
this support, but tc/ct developers wanted to have this in.

I think no crash is going, so let's better route this through
nf-next.git.

> Fixes: 4e8d9584d154 ("netfilter: flowtable: Support GRE")
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 2aa2647ed9df..051b15aecd89 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -237,6 +237,18 @@ static void flow_offload_fixup_ct(struct flow_offload *flow)
>  		timeout = READ_ONCE(tn->timeouts[state]);
>  		expired = nf_flow_has_expired(flow);
>  		offload_timeout = READ_ONCE(tn->offload_timeout);
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	} else if (l4num == IPPROTO_GRE) {
> +		const struct nf_gre_net *tn = nf_gre_pernet(net);
> +		enum gre_conntrack state =
> +			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
> +			GRE_CT_REPLIED : GRE_CT_UNREPLIED;
> +
> +		timeout = READ_ONCE(tn->timeouts[state]);
> +		expired = nf_flow_has_expired(flow);
> +		/* GRE has no offload timeout: see flow_offload_get_timeout(). */
> +		offload_timeout = NF_FLOW_TIMEOUT;
> +#endif
>  	} else {
>  		return;
>  	}
> -- 
> 2.53.0
> 
> 
