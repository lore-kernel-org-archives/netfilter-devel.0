Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F35D320A01
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756922284; cv=none; b=p/33XV+/dJsAUK87CxkfH/EvzBDK7er6PYyRXJzkGw/Zc23d1DVe/T+xZBOMA9hSkfsdkfII521ljEY2Fg4FPRQ05jXh8SgN4TQYkhvz1dXYrGo1Z4uO/6I4n5qgSlfHu7AY0UCoTR0EUbgNp4d1MV8+K2iXXFxaBwWGyaNwg/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756922284; c=relaxed/simple;
	bh=Nbd3yiR1w7Bgn+FuSaSletYR7gYfuJY7LY9x5Xqtj+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsRnGbCEFKKsaSFbW/ttvyVBECyNmqrztLI1k1W52YTrdkLa04K9hAz7QmX0tG11CoGLnKCqgYltrTW7cspBK0n2aXRCYoNQuTdUrJcCzdf+7RHLPUnu8yt2HR7nHz2UbSfOsGm1ScCmq1/QnTMeX++6XtsUZV40p8NQwl4xTjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cpcAa38i; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cpcAa38i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756922283; x=1788458283;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Nbd3yiR1w7Bgn+FuSaSletYR7gYfuJY7LY9x5Xqtj+0=;
  b=cpcAa38ilk8wf4S5DhZE1RNT4CYL26NAXaqbpB4Ho77QVVrkYvyPxOPR
   xcdGj2hzqsSrxL2KX6OmBBh17TkPS6m0rRHTEnQ87m/UUgkluHuI9FNl+
   j7/g+/79+vf2BFp97RpgFzVKTWEQhujrPd93H0FjlJEk2fFbu/mqi3WHT
   itT7dABFGOclkgwASBuLLoeW2sysGfem0R0Wce12dZmQX0d8/29WEODC5
   qle66c9Gj53H8ManwvJZRPw1pCiUH+9te093gBV9dGMWaYkTfA2AKCzfq
   6U5A/imNpleksq4vKG/F0r2f9b+QLtwlC2jah0L14bE8RpGdCuEbUw+i6
   g==;
X-CSE-ConnectionGUID: bKmksy/3RZu8pYDW04xSnw==
X-CSE-MsgGUID: zSvX1qykQyaIcuAVvG3bHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="63069291"
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="63069291"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 10:57:59 -0700
X-CSE-ConnectionGUID: MkUafq2YTXCbSo7grNs7kw==
X-CSE-MsgGUID: ne87HntxQOKiZpWz3WdhSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="176021621"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 03 Sep 2025 10:57:57 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utrk2-0004GZ-2J;
	Wed, 03 Sep 2025 17:57:54 +0000
Date: Thu, 4 Sep 2025 01:56:58 +0800
From: kernel test robot <lkp@intel.com>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	pablo@netfilter.org, fw@strlen.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
Message-ID: <202509040107.KmDmcM3p-lkp@intel.com>
References: <20250902215433.75568-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902215433.75568-1-nickgarlis@gmail.com>

Hi Nikolaos,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on horms-ipvs/master linus/master v6.17-rc4 next-20250903]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikolaos-Gkarlis/netfilter-nft_ct-reject-ambiguous-conntrack-expressions-in-inet-tables/20250903-055737
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250902215433.75568-1-nickgarlis%40gmail.com
patch subject: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack expressions in inet tables
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20250904/202509040107.KmDmcM3p-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250904/202509040107.KmDmcM3p-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509040107.KmDmcM3p-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nft_ct.c:444:4: error: expected expression
     444 |                         const struct nft_expr *curr, *last;
         |                         ^
>> net/netfilter/nft_ct.c:449:27: error: use of undeclared identifier 'curr'
     449 |                         nft_rule_for_each_expr(curr, last, expr->rule) {
         |                                                ^
>> net/netfilter/nft_ct.c:449:33: error: use of undeclared identifier 'last'
     449 |                         nft_rule_for_each_expr(curr, last, expr->rule) {
         |                                                      ^
>> net/netfilter/nft_ct.c:449:27: error: use of undeclared identifier 'curr'
     449 |                         nft_rule_for_each_expr(curr, last, expr->rule) {
         |                                                ^
>> net/netfilter/nft_ct.c:449:33: error: use of undeclared identifier 'last'
     449 |                         nft_rule_for_each_expr(curr, last, expr->rule) {
         |                                                      ^
>> net/netfilter/nft_ct.c:449:27: error: use of undeclared identifier 'curr'
     449 |                         nft_rule_for_each_expr(curr, last, expr->rule) {
         |                                                ^
>> net/netfilter/nft_ct.c:449:27: error: use of undeclared identifier 'curr'; did you mean 'err'?
     449 |                         nft_rule_for_each_expr(curr, last, expr->rule) {
         |                                                ^~~~
         |                                                err
   include/net/netfilter/nf_tables.h:1064:30: note: expanded from macro 'nft_rule_for_each_expr'
    1064 |              (expr) = nft_expr_next(expr))
         |                                     ^
   net/netfilter/nft_ct.c:389:6: note: 'err' declared here
     389 |         int err;
         |             ^
   net/netfilter/nft_ct.c:450:9: error: use of undeclared identifier 'curr'; did you mean 'err'?
     450 |                                 if (curr == expr)
         |                                     ^~~~
         |                                     err
   net/netfilter/nft_ct.c:389:6: note: 'err' declared here
     389 |         int err;
         |             ^
   net/netfilter/nft_ct.c:453:9: error: use of undeclared identifier 'curr'
     453 |                                 if (curr->ops == &nft_meta_get_ops) {
         |                                     ^
   net/netfilter/nft_ct.c:454:50: error: use of undeclared identifier 'curr'; did you mean 'err'?
     454 |                                         const struct nft_meta *meta = nft_expr_priv(curr);
         |                                                                                     ^~~~
         |                                                                                     err
   net/netfilter/nft_ct.c:389:6: note: 'err' declared here
     389 |         int err;
         |             ^
   10 errors generated.


vim +444 net/netfilter/nft_ct.c

   382	
   383	static int nft_ct_get_init(const struct nft_ctx *ctx,
   384				   const struct nft_expr *expr,
   385				   const struct nlattr * const tb[])
   386	{
   387		struct nft_ct *priv = nft_expr_priv(expr);
   388		unsigned int len;
   389		int err;
   390	
   391		priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
   392		priv->dir = IP_CT_DIR_MAX;
   393		switch (priv->key) {
   394		case NFT_CT_DIRECTION:
   395			if (tb[NFTA_CT_DIRECTION] != NULL)
   396				return -EINVAL;
   397			len = sizeof(u8);
   398			break;
   399		case NFT_CT_STATE:
   400		case NFT_CT_STATUS:
   401	#ifdef CONFIG_NF_CONNTRACK_MARK
   402		case NFT_CT_MARK:
   403	#endif
   404	#ifdef CONFIG_NF_CONNTRACK_SECMARK
   405		case NFT_CT_SECMARK:
   406	#endif
   407		case NFT_CT_EXPIRATION:
   408			if (tb[NFTA_CT_DIRECTION] != NULL)
   409				return -EINVAL;
   410			len = sizeof(u32);
   411			break;
   412	#ifdef CONFIG_NF_CONNTRACK_LABELS
   413		case NFT_CT_LABELS:
   414			if (tb[NFTA_CT_DIRECTION] != NULL)
   415				return -EINVAL;
   416			len = NF_CT_LABELS_MAX_SIZE;
   417			break;
   418	#endif
   419		case NFT_CT_HELPER:
   420			if (tb[NFTA_CT_DIRECTION] != NULL)
   421				return -EINVAL;
   422			len = NF_CT_HELPER_NAME_LEN;
   423			break;
   424	
   425		case NFT_CT_L3PROTOCOL:
   426		case NFT_CT_PROTOCOL:
   427			/* For compatibility, do not report error if NFTA_CT_DIRECTION
   428			 * attribute is specified.
   429			 */
   430			len = sizeof(u8);
   431			break;
   432		case NFT_CT_SRC:
   433		case NFT_CT_DST:
   434			if (tb[NFTA_CT_DIRECTION] == NULL)
   435				return -EINVAL;
   436	
   437			switch (ctx->family) {
   438			case NFPROTO_IPV4:
   439				len = sizeof_field(struct nf_conntrack_tuple,
   440						   src.u3.ip);
   441				break;
   442			case NFPROTO_IPV6:
   443			case NFPROTO_INET:
 > 444				const struct nft_expr *curr, *last;
   445				bool meta_nfproto = false;
   446				if (!expr->rule)
   447					return -EINVAL;
   448	
 > 449				nft_rule_for_each_expr(curr, last, expr->rule) {
   450					if (curr == expr)
   451						break;
   452	
   453					if (curr->ops == &nft_meta_get_ops) {
   454						const struct nft_meta *meta = nft_expr_priv(curr);
   455						if (meta->key == NFT_META_NFPROTO) {
   456							meta_nfproto = true;
   457							break;
   458						}
   459					}
   460				}
   461				if (!meta_nfproto)
   462					return -EINVAL;
   463	
   464				len = sizeof_field(struct nf_conntrack_tuple,
   465						   src.u3.ip6);
   466				break;
   467			default:
   468				return -EAFNOSUPPORT;
   469			}
   470			break;
   471		case NFT_CT_SRC_IP:
   472		case NFT_CT_DST_IP:
   473			if (tb[NFTA_CT_DIRECTION] == NULL)
   474				return -EINVAL;
   475	
   476			len = sizeof_field(struct nf_conntrack_tuple, src.u3.ip);
   477			break;
   478		case NFT_CT_SRC_IP6:
   479		case NFT_CT_DST_IP6:
   480			if (tb[NFTA_CT_DIRECTION] == NULL)
   481				return -EINVAL;
   482	
   483			len = sizeof_field(struct nf_conntrack_tuple, src.u3.ip6);
   484			break;
   485		case NFT_CT_PROTO_SRC:
   486		case NFT_CT_PROTO_DST:
   487			if (tb[NFTA_CT_DIRECTION] == NULL)
   488				return -EINVAL;
   489			len = sizeof_field(struct nf_conntrack_tuple, src.u.all);
   490			break;
   491		case NFT_CT_BYTES:
   492		case NFT_CT_PKTS:
   493		case NFT_CT_AVGPKT:
   494			len = sizeof(u64);
   495			break;
   496	#ifdef CONFIG_NF_CONNTRACK_ZONES
   497		case NFT_CT_ZONE:
   498			len = sizeof(u16);
   499			break;
   500	#endif
   501		case NFT_CT_ID:
   502			if (tb[NFTA_CT_DIRECTION])
   503				return -EINVAL;
   504	
   505			len = sizeof(u32);
   506			break;
   507		default:
   508			return -EOPNOTSUPP;
   509		}
   510	
   511		if (tb[NFTA_CT_DIRECTION] != NULL) {
   512			priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
   513			switch (priv->dir) {
   514			case IP_CT_DIR_ORIGINAL:
   515			case IP_CT_DIR_REPLY:
   516				break;
   517			default:
   518				return -EINVAL;
   519			}
   520		}
   521	
   522		priv->len = len;
   523		err = nft_parse_register_store(ctx, tb[NFTA_CT_DREG], &priv->dreg, NULL,
   524					       NFT_DATA_VALUE, len);
   525		if (err < 0)
   526			return err;
   527	
   528		err = nf_ct_netns_get(ctx->net, ctx->family);
   529		if (err < 0)
   530			return err;
   531	
   532		if (priv->key == NFT_CT_BYTES ||
   533		    priv->key == NFT_CT_PKTS  ||
   534		    priv->key == NFT_CT_AVGPKT)
   535			nf_ct_set_acct(ctx->net, true);
   536	
   537		return 0;
   538	}
   539	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
