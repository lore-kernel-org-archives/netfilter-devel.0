Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.126
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794996694;
	b=aP07lN3X5g/Lyim7b93ATzfp3GJ8UWT0Dus32OCdqa5jGDgVB3eI7pyYdHToUpLxuI9y
	 GtzsdWstIbfiSc9ISbsYnI57HmHxHQ2O6mFoMcohtwUBY2LcGjRvVOmkQu4eniLsQSzzW
	 pZ0hlYLna5W3DtO1iYMr+0NiTo7sCcU3VJ+H4SIAG5y0WHuJA5RlZ1vas2skkIhVuF2s+
	 8PKfDN/FJZWedSEoChx+1G9OXIrPQwY7pmrBPy787RqnRxa2AIkof8RU80/eunwzuBL8/
	 R3DPTeM+FPQ4aUKTXOH5LOBEhv6DXhgMAT8NySI0b6bmw6SoBwUmIZFMekn6Kzu1xaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794996694;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=D1MUY1H0VH1qHinNrqNAjg4w0W1AM6O//IjCUC504uI=;
	b=W8Nkrvz/5z6QcLjM1RsYvz6JIQtNyxUJVjWnbVUamLK6sqn6ynemJIHI0XqX8zIksbXy
	 2OhK8w3/AK3YP23RMDzzLeG/7YQITM5vgCSTnprUCMK+jBeqqx3nX1cHUjYlBB1PNDFI2
	 zxAK/8Ck8+Kou8tRdJeWBsLs5SHWuaewzZFzMFVfeOwB1URCajmsjVaTwhOizQcKDr3xH
	 WTKRjpDwyP4umGkQoBDkYtj1UdBHR+dCqeER3+fli9lNSUjSbtIQqTEZhDND8IOrKNojJ
	 S3KK6xI+6INDJY41qVSYyzwjDPxIxzX/vGr5wYbPY6QzKx5d9cA9zQgat1JfSOh+f9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OW5EI13u;
	arc=none smtp.remote-ip=91.218.175.126
Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D51606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:11:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9D51606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OW5EI13u
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+bB9g6Bv+semol6SWgegbWp0lH/3VoQYPrulmmDo324=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794996692; v=1; x=1795601492;
 b=OW5EI13uRMfGhs6ixdrLLuvaMP7KYvOoEEPvlEROAbKL1hYGSDT2CH4udseFxC7OBPwu+guP
 WNikBVVefcDsLc2OrtBc6DErGrO5w78T33QBmgpjThOx/ayqYPMVkdUo/13JRDD6T31YSBw7TBR
 J5GzMsPAe/k2v2ehEk0LYZlI=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d58a89dcce9aff1c;
	Wed, 18 Nov 2026 10:11:32 +0000
X-Mizu-Trace-ID: d58a89dcce9aff1c
X-Migadu-Flow: FLOW_OUT
Message-ID: <6c94d413-02b8-4a1d-8a5f-9503a9ff4815@linux.dev>
Date: Wed, 18 Nov 2026 19:11:26 +0900
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
Subject: Re: [PATCH nf v2 1/2] netfilter: nf_tables: only disable tables on a
 dormant transition
To: Ma Xinmeng <1564938642@qq.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
References: <20261117161520.1031-1-1564938642@qq.com>
 <tencent_6731DB02656EFC3D74E4DFCE582B7E0EFC0A@qq.com>
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
In-Reply-To: <tencent_6731DB02656EFC3D74E4DFCE582B7E0EFC0A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/11/18 at 1:14 Ma Xinmeng wrote:
> nf_tables_commit() calls nf_tables_table_disable() for every NEWTABLE
> transaction that has NFT_TABLE_F_DORMANT set and __NFT_TABLE_F_UPDATE.
> Since table adoption introduced __NFT_TABLE_F_WAS_ORPHAN, UPDATE no
> longer implies a dormant state change: re-owning an already dormant
> PERSIST orphan sets UPDATE because of the adoption, even though the
> table never left the dormant state. The commit then clears DORMANT,
> walks the basechains, and unregisters a hook that was never registered,
> which triggers WARN_ONCE("hook not found") in
> __nf_unregister_net_hook().
> 
> Use __NFT_TABLE_F_WAS_AWAKEN, which records an awake-to-dormant
> transition, instead of the current DORMANT flag. This skips the disable
> for an already dormant adopted table while preserving the genuine
> awake-to-dormant path.
> 
> Fixes: 31bf508be656 ("netfilter: nf_tables: Implement table adoption support")
> Signed-off-by: Ma Xinmeng <1564938642@qq.com>
The patch looks good to me.

Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Thanks,
Xuanqiang
