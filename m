Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996509;
	b=Yl0NA9xILu/aM37vhlL7KxwSEqm3iWhCd8orSpeKg7RmbJeR1K2Q02eKG12gCNLJ1eQ8
	 BbLGkL6BbS6PuUemRJ+6sKc2ADXAvW1iOFnFOYCq2Q19ANTnQSInbT/wZcrR5jzK8lIWx
	 5rkz3RcZ3CpORiWpN4Fxn+wZdkDhUieUrJX4lBFMzGFSELfaUo4aVAbHFhUFPpmVIkpzO
	 RRFYzlsz0dNMhLui8VHB/7Ta4U4rETjE1fqPQfqI4VyeOsyRs1s9o+xnxdjB/LkJIbTRV
	 uJc5BShJey0EZQeGmrfGL3xQqR6yjPfEMFwGYVJjSqkw2MVnqW5jVh/IqcwC0Hrb9jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996509;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Qz2aEB2Nm1ekmcMD9FQ6yh0BCWvEwRLtp4myOxqi53s=;
	b=xvug7MeTFHxSZDrQ3/Tz0EUfZMckjb48J66FBj15crC3Xkctuv3c9n1GNuLvDPHRlDvp
	 ynmI8lN3VV9C7TvUWHs9NgxK8rP86IKOuAt58YfvPtn7KO9/nkzkErIdQRb6rkJfLeLpr
	 eOn4Gr7gPO3NuReIVZnNV7XzdNZjN9O99LEUN97+mZU+aOOzkdedChx5iLClk4TLPbDlN
	 x4MJfO3WT5hdCLmGE1hlEL53ELt3kV1o5g56B6GgVL/McEmYtUbwAV/KQAQpQoCme0vAC
	 1kS+k9Ej18VxGgKr9x4rfiVStvJsaw88v4QZ+ca87XOKzp6mL/fk5UxJ4NhYXyS0qJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pvWn780c;
	arc=none smtp.remote-ip=91.218.175.55
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBA3606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:08:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BBA3606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pvWn780c
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gTWWkKNqiGiRm5q5+vRO1BZhUiAhUFJJwPIYPbRkP/0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794996506; v=1; x=1795601306;
 b=pvWn780cvjz07h0JxdIkHrHAA27ZRq2+QqgnlGqPSPRyIooFg3Xi5ZYYLtM2vLo72rP+o2c3
 HbYBls0ph9N+wm9SG5hyXsris8Ks7igLmdNHikAPjhcmVSMz1Ywr9gE9MNTw/G6uoLDEYYlKmsL
 Ow/5niY1FJxFehINNkag3asE=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7d48908e68266c64;
	Wed, 18 Nov 2026 10:08:26 +0000
X-Mizu-Trace-ID: 7d48908e68266c64
X-Migadu-Flow: FLOW_OUT
Message-ID: <10f12bd4-6b0b-4e94-8228-04d73a62daf0@linux.dev>
Date: Wed, 18 Nov 2026 19:08:19 +0900
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf v2 0/2] netfilter: nf_tables: only disable tables on a
 dormant transition
To: Ma Xinmeng <1564938642@qq.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
References: <tencent_80CDC0280E0D4030AF01A16E583E88E7970A@qq.com>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <tencent_80CDC0280E0D4030AF01A16E583E88E7970A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/11/18 at 1:14 Ma Xinmeng wrote:
> Hi,
> 
> This is v2 of the fix for the nftables WARN below. v1 was sent as
> [PATCH net] and tracked a per-basechain "registered" flag. Xuanqiang
> suggested fixing the commit condition instead: a dormant table never has
> a registered basechain hook, and nf_tables_commit() should not call
> nf_tables_table_disable() for a table that is already dormant.
> 
> v2 drops the new field and changes only the NEWTABLE commit path:
> 
> - if (table->flags & NFT_TABLE_F_DORMANT)
> + if (table->flags & __NFT_TABLE_F_WAS_AWAKEN)
>        nf_tables_table_disable(net, table);
> 
> __NFT_TABLE_F_WAS_AWAKEN records a real awake-to-dormant transition.
> Since table adoption added __NFT_TABLE_F_WAS_ORPHAN, __NFT_TABLE_F_UPDATE
> can be set for an adoption that leaves the table dormant, so the old
> check disabled the table and unregistered a hook that was never
> registered.
> 
> The WARN was found by FuzzAnything's AI-assisted kernel fuzzer while
> fuzzing nftables netlink messages in a user and network namespace, and
> I reproduced it at runtime on 7.3.0-rc4, 7.3.1, 7.4-rc1, 7.4-rc2, and
> 7.4-rc3. The baseline 7.4-rc3 dmesg is:
> 
>    hook not found, pf 2 num 3
>    WARNING: net/netfilter/core.c:522 at __nf_unregister_net_hook+0x71/0x1b0
>    Call Trace:
>      nft_table_disable+0x78/0xa0
>      nf_tables_commit+0x1c03/0x1ec0
>      nfnetlink_rcv_batch+0x939/0xaf0
> 
> v2 was tested on 7.4.0-rc3-c027fixv2: the PoC returns 0 and dmesg has no
> WARN. I also checked a real awake-to-dormant transition: after the table
> became dormant, a ping left the basechain counter at 0, so the hook was
> still unregistered correctly.
> 
> Changes in v2:
> - remove the per-basechain registered field
> - check __NFT_TABLE_F_WAS_AWAKEN instead of NFT_TABLE_F_DORMANT
> - add Fixes: 31bf508be656 ("netfilter: nf_tables: Implement table adoption support")
> - use [PATCH nf] as requested
> - add a selftest as 2/2
> 

It would be nice to add a link to v1 here.

> The selftest uses the nft owner/persist table flags to create the
> dormant orphan, and checks the kernel taint state rather than parsing
> dmesg. It fails on unpatched 7.4-rc3 and passes on v2.
> 
> Thanks,
> Ma Xinmeng
> 
> Ma Xinmeng (2):
>    netfilter: nf_tables: only disable tables on a dormant transition
>    selftests: netfilter: test re-owning an already dormant table
> 
>   net/netfilter/nf_tables_api.c                 |  2 +-
>   .../testing/selftests/net/netfilter/Makefile  |  1 +
>   .../net/netfilter/nft_table_dormant_adopt.sh  | 57 +++++++++++++++++++
>   3 files changed, 59 insertions(+), 1 deletion(-)
>   create mode 100755 tools/testing/selftests/net/netfilter/nft_table_dormant_adopt.sh
> 

