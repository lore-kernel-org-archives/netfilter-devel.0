Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56B4481658
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792233465; cv=pass; b=tUslgcXDISnGsUtgUhfyDGDIP/vOD8dnzIAxDAspQAx6FMFDPoimwIr1pmNNmzEkATv7YTmlsSpnpO9Fz4gR6hzoJbb9UMmsN131OdepVnrZ3l1IQoABgxg+CKhhSwAibfBZX3iSfVOQC8eYYBz5y5TvEyKJZpTUQEtXEkjsNX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792233465; c=relaxed/simple;
	bh=DdTRwYsOyMO2Pon1eB9HGGKKuUN6WYiZ/XENSt+d+ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i9/qFT11JD+UjqQV3+tPdAUpbl0K+kLX4Eu7kOzuC+NN99xRSALRsTG9V2pTdsmzk0sHcQ+FeSzPxaX62BWjGzagAdz5tFGDUL/q6oc14lHKIUozpEhL6BO2dD8VVTeEA/olUBscJUbU0cSyYoj7UTCcyQ7gjGesMt8KAE72OMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=Gz8k7RRe; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="Gz8k7RRe"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6740e7ae219so610767d50.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 03:37:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792233462; cv=none;
        d=google.com; s=arc-20260327;
        b=KtuDB3TutUhXOpyQt6y3PrpRzDvXiiLKDmX16T73rGV9V28sXyG4xpPWgcd2tx5SS9
         KPvoCiA1mSXn2/t+IgffJBdj26+34/TYi7oQ8d5L+w1PFWZMrkPIkrW7bsWoxQNE7zGV
         eiWwTg0/4sQlpZ9cVXr3ZsWaB6358VQK/BYnUUolEjAaRIj9BJ1q/C/eKPOvBTIZQGZG
         WY3h9v5EHr+uvrunj4JkcC6/iuGXfdf4qkj2GNNsSOsjstyhXwonnMAeCGQZ4jt3E3Pg
         UxTAy70EcwkgWSF3YwYRRI5PcngJApPkoqlAh9EFn16kP8rfqpjYf4tDqf4wgQvTSkRn
         7wcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8xQtVA18Ly6EVrTffA/+C9Ju5Q0HewYi23Ad/Eu06YI=;
        fh=QunbvaQ4C9YKUh+jeoC2bpmRClLMMAcpASKq0ct3s9w=;
        b=Z3IB8ztn4ICnk+dMY8bnn11ccEPJtlpYCxMq76NEznKolHproHCqNgHc2qlOUoQ0zn
         sTN0xMcCr3FgFtqqPcep7qIAXtHK8LoPj/UxKfgFebw5nW8maed5x4SOleSz1d4uj571
         oMYLcThusl4mJgQxuG7iR1CqA93enNa7ZG4onLy6TaQJmVv+WCBJ5yq5YQUVWz1Qc3kv
         CHt8SH3bjmanKGEHshvvx/QynuFb/oSP9uUnufQ8TrMcPJpX6mqTia2F/n2A9zJCTR5c
         oOlQxWbqSsPyy2UMshxjVJgV2Y5yeY/AsQ5NDhIv2+uEm9634dclvRWBSkj99KWMXYmm
         5N7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792233462; x=1792838262; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8xQtVA18Ly6EVrTffA/+C9Ju5Q0HewYi23Ad/Eu06YI=;
        b=Gz8k7RReE/vgqJIU2IlmmvzZtxgqj7Zoz1Pqg9mI57Ea0Zjc9gnNpvTRM8DDyEByI8
         KR4iQRBvgZjjOWswddPDV1Tl/sWmckZUrR2NlxR2jl42h63QQUetaHO6ieZGz/8wmWZ3
         MIMzj31omne/mFjOOAKGgAvjQvM4c5omH1sOhnT8KjKTdWh1dAQoSfuwK6uVJCwBNqPh
         T1TQ6e8QIYjRj9JeRF+24xakerjrFEM5UAcQ4d4Iy3cwyT2oKVeqH5JvCYZfYnk3oJYk
         emC21QpdAUUd5mZGxoOv7FN+tsAPAl43Cx/+SW3/XatAAY+2Jukl3l07heiWDmO3MnXX
         02UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792233462; x=1792838262;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8xQtVA18Ly6EVrTffA/+C9Ju5Q0HewYi23Ad/Eu06YI=;
        b=rnXJuqQMRu6broazmxbyDby6KZzgeKVIV8WpXNWL/Mp08GrzxhL5ZNCgHhVJmaZkiV
         DcQWGxFDD9DFRUYeSCSx87tdzh7YejsZhz3nRkF8TLtBUPTgcmqbr0Dohpi2rL5DoBzm
         aW3YaHRsWVZo4yvR5x3IzFJEcZLWDatMiq9+m+Mg4Sj+PVM5i2ERP/mrnxOeGqfgfqWI
         3TtW9lL+doNr5NIO64+PRmAN24a5kAl/WkRmG2rUG7DXCA9Uao/pJ8gg7vKB4qy308iR
         o1vXcFSrq+VgOiOpOfZ7MiXCHMT8H3fSlEZTC1bd5qMeqFh3I+ao3jgj0TbeedmkOUGO
         JT9w==
X-Gm-Message-State: AFq9FYLD4h0Xcs42/Aj1DK15wv4m2fy5YG8lq1y1SZKBi9vLnEYLzoVh
	WXGklSmOqAivsYEjVuyt44xfAIINxZig+9Jl6taI+5ScG4u74nSEXAEF2wM93aaM8/RUa/EPQW4
	2qrE0Kzeur23XSkSJggwzVM9pDX9cQZHONVmAU3M9426kz6pEnqZ4hKgd
X-Gm-Gg: AYBFou1/I16bI/wfLfvgkxH88oC93Qo9QsNdZZKE1flp3rt12B82cSxgX8pazZYCJev
	ve5eLGH2O7OWDJjs/vuhTYIVxlDVjH2PNHxL5qdh7yogdSZl0HRvKl/W9UJY90dIVR7QFgIHa6L
	dlMsMuHRwbgxNe3fgqiKNu4c7m5GZOeeuj6hcEJk0JKhbWMLo8je9AQ9/XcGaXUC5XfBi0DIr6B
	dCiRtuulDbr8eEgQVKdUbqeYnwXjn6d+mVbAeRrmHajUmQSu9hKo9emL+vYUfwWlFYP1rljN7To
	p9qocPT4MWt7QTv8eYQp6MmEIMrOcYmX4jS/LkZZsBEeOFKYp/7s0mb7x71MaegcR3IhsfQyO/G
	yDmN133qlq7Hgkwr5UO2MGqH9QMhnySPl+yD9FKuoWq66a7Od7nkVBMCtTN9wKFnzMmyCpxSETd
	4WnIY4sM9emdcG5KV+BCLFiSdIIAPpdKskUJB7GuoKIDfYXwP8sZ6+spsIgpMwCoN3f9i12gxBK
	0GldxJiII++EM15uByY+CDy4uFTRS4VuZC+QibwW8y+/dJKrjqKwgIiRFb9jluD+mk7uYKAibUo
	Yz1agHpTpo5iJg==
X-Received: by 2002:a05:690e:1913:b0:674:981:a937 with SMTP id
 956f58d0204a3-679ca914780mr522735d50.121.1792233461776; Sat, 17 Oct 2026
 03:37:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004171616.3544880-1-julius@bairaktaris.de>
In-Reply-To: <20261004171616.3544880-1-julius@bairaktaris.de>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Sat, 17 Oct 2026 10:37:05 +0000
X-Gm-Features: AclHuK-ma-16nXT2QPoniX4Y6rIglK1_-HkBDcD-pfQT-pjJWoWmgSkOWis1dDQ
Message-ID: <CAC1t37LLnXEaD2YDSj1iBBxezSKjHGNqm_AR9G4s5Nhy_O=9mA@mail.gmail.com>
Subject: Re: [PATCH nf-next 0/3] netfilter: flowtable: update upper device
 stats in the fast path
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, 
	netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, andrew+netdev@lunn.ch, 
	shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@nbd.name
Content-Type: text/plain; charset="UTF-8"

Hi Pablo, Florian,

gentle ping on this series. Let me know if you'd like anything
changed.

Thanks,
Julius


Am So., 4. Okt. 2026 um 17:16 Uhr schrieb Julius Bairaktaris
<julius@bairaktaris.de>:
>
> With the software flowtable, packets bypass the bridge, VLAN, PPPoE and
> tunnel devices above the flowtable device, so their counters only see
> the first packets of each connection. The classic forwarding path
> always counts them, so this series does too, without a flag.
>
> Patch 1 adds VLAN stats helpers; it touches include/linux/if_vlan.h, so
> a netdev ack would let it go through nf-next. Patch 2 updates the
> counters from the fast path with the lengths the classic path counts.
> Patch 3 adds bridge, VLAN and tunnel counter checks to nft_flowtable.sh,
> which fail without patches 1 and 2.
>
> Hardware offloaded flows are not counted. A GSO packet sent through a
> PPPoE device counts once, not once per segment.
>
> Cost: struct flow_offload grows from 296 to 328 bytes (slab object 320
> to 384). Forwarding from a bridge with a VLAN port to a veth in an x86
> guest, mean of three interleaved runs without/with the series: TCP
> 55.7/55.0 Gbit/s, 64 byte UDP 177/173 kpps.
>
> This series was written with the help of an AI coding assistant. I have
> reviewed and tested it.
>
> Julius Bairaktaris (3):
>   8021q: add vlan_dev_sw_netstats_rx_add() and
>     vlan_dev_sw_netstats_tx_add()
>   netfilter: flowtable: update upper device stats in the fast path
>   selftests: netfilter: nft_flowtable.sh: check upper device counters
>
>  include/linux/if_vlan.h                       | 36 ++++++++++
>  include/net/netfilter/nf_flow_table.h         |  8 ++-
>  net/netfilter/nf_flow_table_core.c            |  3 +
>  net/netfilter/nf_flow_table_ip.c              | 53 +++++++++++++++
>  net/netfilter/nf_flow_table_path.c            |  9 +++
>  .../selftests/net/netfilter/nft_flowtable.sh  | 67 +++++++++++++++++++
>  6 files changed, 175 insertions(+), 1 deletion(-)
>
>
> base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
> --
> 2.53.0
>
