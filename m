Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C749B3914E8
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Apr 2026 07:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777274801; cv=none; b=sj3JalMoPsiEddJW0xowweEIpATgPNnvLo166qAINcpUjec5e4r0ISifuvKeJbFjKRCLUiSwhg/j8SzyICfjwqgmKzqsQyBE3tyX76h38mE8PuIDx2eOIPAvUAqcHcLoS5RImQifyMbcntSwfucECSADjdd6dXPyhWWXxEU91NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777274801; c=relaxed/simple;
	bh=EkOtIce6c3DuSG89AlBWhJ1i7WGzy0J8+ZjAQPer1zo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aj99NLUMhwI1GRufqwADUTNMQOBYaroS+5KR5ZUyrDWrtJTvDp+J21051Ny9fbVFAP7bNBR7FWMAMkFXlijiWBo1hFBMj5jhpIx6lLSK19cgSU54PwkGYhyhR8GOsmCM3lSor0J8VNZRtuOpHX6VBaHQPKB8vqTdqQy6qhk440k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NIwbJ2Iu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+UwXebDx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NIwbJ2Iu; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+UwXebDx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NIwbJ2Iu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+UwXebDx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NIwbJ2Iu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+UwXebDx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 07C916A938;
	Mon, 27 Apr 2026 07:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777274798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0NbF6aD5HiuPFS4MuEa2X7yOTEQggqU7pIs8GjdmE=;
	b=NIwbJ2IupiUSMeO7elcTBQbJveMSujtOEo6LONEOufCnB4ChMSIF1n6oS48Msdwkm9Cgk9
	EstgJe82aw0h1UdCWDC0qsEO7dA8rzOdqdgzcxjbpPqTDR8E3W2YWGkKB9IIe03FsT1rPY
	j9KNY/HIvTYRbs/0LW4DIT6FdGjV8+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777274798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0NbF6aD5HiuPFS4MuEa2X7yOTEQggqU7pIs8GjdmE=;
	b=+UwXebDx+Le2oUVJ3FAzM8JCwWrrBuoIWzpiYhg5gTDMHsao78YZLUUpaKvrYt3L+7MZXc
	U6EiJepaxlpjWjCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777274798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0NbF6aD5HiuPFS4MuEa2X7yOTEQggqU7pIs8GjdmE=;
	b=NIwbJ2IupiUSMeO7elcTBQbJveMSujtOEo6LONEOufCnB4ChMSIF1n6oS48Msdwkm9Cgk9
	EstgJe82aw0h1UdCWDC0qsEO7dA8rzOdqdgzcxjbpPqTDR8E3W2YWGkKB9IIe03FsT1rPY
	j9KNY/HIvTYRbs/0LW4DIT6FdGjV8+w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777274798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TW0NbF6aD5HiuPFS4MuEa2X7yOTEQggqU7pIs8GjdmE=;
	b=+UwXebDx+Le2oUVJ3FAzM8JCwWrrBuoIWzpiYhg5gTDMHsao78YZLUUpaKvrYt3L+7MZXc
	U6EiJepaxlpjWjCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 967F8593B0;
	Mon, 27 Apr 2026 07:26:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0fPEIa0P72kjVgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 27 Apr 2026 07:26:37 +0000
Message-ID: <e6315242-d34d-4a9a-824e-c9ebf0b03c83@suse.de>
Date: Mon, 27 Apr 2026 09:26:28 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf-next v5] netfilter: nf_tables: add math expression
 support
To: kernel test robot <lkp@intel.com>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, coreteam@netfilter.org, phil@nwl.cc,
 fw@strlen.de, pablo@netfilter.org
References: <20260421155859.7049-2-fmancera@suse.de>
 <202604261140.gX71SoJp-lkp@intel.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <202604261140.gX71SoJp-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:mid,intel.com:email,01.org:url,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,intel.com:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 4/26/26 5:57 AM, kernel test robot wrote:
> Hi Fernando,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on nf-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Fernando-Fernandez-Mancera/netfilter-nf_tables-add-math-expression-support/20260424-055358
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git master
> patch link:    https://lore.kernel.org/r/20260421155859.7049-2-fmancera%40suse.de
> patch subject: [PATCH nf-next v5] netfilter: nf_tables: add math expression support
> config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260426/202604261140.gX71SoJp-lkp@intel.com/config)
> compiler: nios2-linux-gcc (GCC) 11.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260426/202604261140.gX71SoJp-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202604261140.gX71SoJp-lkp@intel.com/
> 

I am completely lost here. How is this happening? I do not see any of 
these errors locally with W=1.

> All error/warnings (new ones prefixed by >>):
> 
>     net/netfilter/nft_math.c: In function 'nft_math_eval_bitmask':
>     net/netfilter/nft_math.c:49:17: error: implicit declaration of function 'DEBUG_NET_WARN_ONCE'; did you mean 'DEBUG_NET_WARN_ON_ONCE'? [-Werror=implicit-function-declaration]
>        49 |                 DEBUG_NET_WARN_ONCE(true, "unknown operation path in nft_math");
>           |                 ^~~~~~~~~~~~~~~~~~~
>           |                 DEBUG_NET_WARN_ON_ONCE
>     net/netfilter/nft_math.c: In function 'nft_math_init':
>     net/netfilter/nft_math.c:95:39: error: passing argument 1 of 'nft_parse_register_load' from incompatible pointer type [-Werror=incompatible-pointer-types]
>        95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
>           |                                       ^~~
>           |                                       |
>           |                                       const struct nft_ctx *

What? But I see:

int nft_parse_register_load(const struct nft_ctx *ctx,
                             const struct nlattr *attr, u8 *sreg, u32 len);

Is this a bogus report?

>     In file included from net/netfilter/nft_math.c:4:
>     include/net/netfilter/nf_tables.h:235:50: note: expected 'const struct nlattr *' but argument is of type 'const struct nft_ctx *'
>       235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
>           |                             ~~~~~~~~~~~~~~~~~~~~~^~~~
>     net/netfilter/nft_math.c:95:46: error: passing argument 2 of 'nft_parse_register_load' from incompatible pointer type [-Werror=incompatible-pointer-types]
>        95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
>           |                                            ~~^~~~~~~~~~~~~~~~
>           |                                              |
>           |                                              const struct nlattr *
>     In file included from net/netfilter/nft_math.c:4:
>     include/net/netfilter/nf_tables.h:235:60: note: expected 'u8 *' {aka 'unsigned char *'} but argument is of type 'const struct nlattr *'
>       235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
>           |                                                        ~~~~^~~~
>>> net/netfilter/nft_math.c:95:64: warning: passing argument 3 of 'nft_parse_register_load' makes integer from pointer without a cast [-Wint-conversion]
>        95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
>           |                                                                ^~~~~~~~~~~
>           |                                                                |
>           |                                                                u8 * {aka unsigned char *}
>     In file included from net/netfilter/nft_math.c:4:
>     include/net/netfilter/nf_tables.h:235:70: note: expected 'u32' {aka 'unsigned int'} but argument is of type 'u8 *' {aka 'unsigned char *'}
>       235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
>           |                                                                  ~~~~^~~
>>> net/netfilter/nft_math.c:95:15: error: too many arguments to function 'nft_parse_register_load'
>        95 |         err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
>           |               ^~~~~~~~~~~~~~~~~~~~~~~
>     In file included from net/netfilter/nft_math.c:4:
>     include/net/netfilter/nf_tables.h:235:5: note: declared here
>       235 | int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
>           |     ^~~~~~~~~~~~~~~~~~~~~~~
>     net/netfilter/nft_math.c: At top level:
>     net/netfilter/nft_math.c:129:27: error: initialization of 'int (*)(struct sk_buff *, const struct nft_expr *)' from incompatible pointer type 'int (*)(struct sk_buff *, const struct nft_expr *, bool)' {aka 'int (*)(struct sk_buff *, const struct nft_expr *, _Bool)'} [-Werror=incompatible-pointer-types]
>       129 |         .dump           = nft_math_dump,
>           |                           ^~~~~~~~~~~~~
>     net/netfilter/nft_math.c:129:27: note: (near initialization for 'nft_math_op.dump')
>     cc1: some warnings being treated as errors
> 
> 
> vim +/nft_parse_register_load +95 net/netfilter/nft_math.c
> 
>      65	
>      66	static int nft_math_init(const struct nft_ctx *ctx,
>      67				 const struct nft_expr *expr,
>      68				 const struct nlattr * const tb[])
>      69	{
>      70		struct nft_math *priv = nft_expr_priv(expr);
>      71		u32 bitmask_check;
>      72		int err;
>      73		u32 op;
>      74	
>      75		if (!tb[NFTA_MATH_SREG] ||
>      76		    !tb[NFTA_MATH_DREG] ||
>      77		    !tb[NFTA_MATH_BITMASK] ||
>      78		    !tb[NFTA_MATH_OP])
>      79			return -EINVAL;
>      80	
>      81		op = nla_get_u32(tb[NFTA_MATH_OP]);
>      82		if (op > NFT_MATH_OP_MAX)
>      83			return -EOPNOTSUPP;
>      84		priv->op = op;
>      85	
>      86		priv->bitmask = nla_get_u32(tb[NFTA_MATH_BITMASK]);
>      87		if (!priv->bitmask)
>      88			return -EINVAL;
>      89	
>      90		/* check if the bitmask is contiguous, otherwise reject it */
>      91		bitmask_check = priv->bitmask + (priv->bitmask & -priv->bitmask);
>      92		if (bitmask_check & (bitmask_check - 1))
>      93			return -EINVAL;
>      94	
>    > 95		err = nft_parse_register_load(ctx, tb[NFTA_MATH_SREG], &priv->sreg,
>      96					      sizeof(u32));
>      97		if (err < 0)
>      98			return err;
>      99	
>     100		return nft_parse_register_store(ctx, tb[NFTA_MATH_DREG],
>     101						&priv->dreg, NULL, NFT_DATA_VALUE,
>     102						sizeof(u32));
>     103	}
>     104	
> 

