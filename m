Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DADB2E7F39;
	Wed, 15 Oct 2025 04:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760501842; cv=none; b=nAq0NBL9ht6Z9uFpFGHRYFBuSP70YeD8ya1kJGJuYCONNTyCTcFM0DISDwAUH01NR89nBHzpIYeD8CDu2xgea8ciFz0hPHFd8SeMEHXe9zi73q1kWekH0kGX5coKEJO0dbQuI7O2b7iC+7qAMYyXPCEITM/jQ7qedkjbLsDB7Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760501842; c=relaxed/simple;
	bh=Z4XsrrDqMI9saEZmhkMwpn1Q4R29wTLZDSVSYVv30DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC7//mF/yGZnMf7+3QMXVczRD+3BEsgMCcH9SB1hBM8hLRu5kJ+zO4lbL5BY5Q6E878w0YlcVR71NOtIUFRd1xr6ROyWRCU5p9S9tuRdwi1dChxYqGuva9PzIV9NcEYeatcxQ4y57NZvB0UocCiHpBqX9QPjEUxLSW3wg0IJMuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IBzbdmoO; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IBzbdmoO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760501839; x=1792037839;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z4XsrrDqMI9saEZmhkMwpn1Q4R29wTLZDSVSYVv30DY=;
  b=IBzbdmoOyrIMR8VrContbEXW7ZEVCcVkglTd+Q2ZdzoWRF6eckGmDIov
   VHWPZ9DSmsW47y4sCXJStFBy7asIBudmcsLJBecukEd/nLRlCHSZVkC6n
   bTwOf6uKoALIBjP1btGUfwVTcgtnvQr//ZjdIs99Ho3xgcY55EtjqxmLd
   Sg3Cgavd6zctX5n1dDpXNQVCpNXChrZtMsoN3swykmht8Jt99iSUr0vTa
   qf9aDNP6fdDxrngOM41UOyMgmqRgZ1oHSHPxkol+HEjudHy6+sWLAHsSt
   oQPuowhFGocOOzlSVKo/7LhlRxKovK8w2mMS6DAf1uIrdnpv1GYMbMiiw
   A==;
X-CSE-ConnectionGUID: P5Ox6gRZRCKzHGRIfbQj/Q==
X-CSE-MsgGUID: 2JrcjqaBRJe+tr6LvU/BDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="73345913"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="73345913"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 21:17:18 -0700
X-CSE-ConnectionGUID: DznAJh2/Rkmu/5hCQN85qw==
X-CSE-MsgGUID: vRcacAWSRHi10411GBqGcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="182843609"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 21:17:15 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8swN-0003RH-0L;
	Wed, 15 Oct 2025 04:17:12 +0000
Date: Wed, 15 Oct 2025 12:15:47 +0800
From: kernel test robot <lkp@intel.com>
To: Andrii Melnychenko <a.melnychenko@vyos.io>, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc
Cc: oe-kbuild-all@lists.linux.dev, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] netfilter: Added nfct_seqadj_ext_add() for ftp's
 conntrack.
Message-ID: <202510151220.i78zzYsl-lkp@intel.com>
References: <20251014114334.4167561-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014114334.4167561-1-a.melnychenko@vyos.io>

Hi Andrii,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on nf-next/master horms-ipvs/master linus/master v6.18-rc1 next-20251014]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrii-Melnychenko/netfilter-Added-nfct_seqadj_ext_add-for-ftp-s-conntrack/20251014-194524
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20251014114334.4167561-1-a.melnychenko%40vyos.io
patch subject: [PATCH 1/1] netfilter: Added nfct_seqadj_ext_add() for ftp's conntrack.
config: m68k-multi_defconfig (https://download.01.org/0day-ci/archive/20251015/202510151220.i78zzYsl-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251015/202510151220.i78zzYsl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510151220.i78zzYsl-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_conntrack_ftp.c: In function 'help':
>> net/netfilter/nf_conntrack_ftp.c:394:25: error: implicit declaration of function 'nfct_seqadj_ext_add'; did you mean 'nf_ct_helper_ext_add'? [-Wimplicit-function-declaration]
     394 |                         nfct_seqadj_ext_add(ct);
         |                         ^~~~~~~~~~~~~~~~~~~
         |                         nf_ct_helper_ext_add


vim +394 net/netfilter/nf_conntrack_ftp.c

   368	
   369	static int help(struct sk_buff *skb,
   370			unsigned int protoff,
   371			struct nf_conn *ct,
   372			enum ip_conntrack_info ctinfo)
   373	{
   374		unsigned int dataoff, datalen;
   375		const struct tcphdr *th;
   376		struct tcphdr _tcph;
   377		const char *fb_ptr;
   378		int ret;
   379		u32 seq;
   380		int dir = CTINFO2DIR(ctinfo);
   381		unsigned int matchlen, matchoff;
   382		struct nf_ct_ftp_master *ct_ftp_info = nfct_help_data(ct);
   383		struct nf_conntrack_expect *exp;
   384		union nf_inet_addr *daddr;
   385		struct nf_conntrack_man cmd = {};
   386		unsigned int i;
   387		int found = 0, ends_in_nl;
   388		typeof(nf_nat_ftp_hook) nf_nat_ftp;
   389	
   390		/* Until there's been traffic both ways, don't look in packets. */
   391		if (ctinfo != IP_CT_ESTABLISHED &&
   392		    ctinfo != IP_CT_ESTABLISHED_REPLY) {
   393			if (!nf_ct_is_confirmed(ct))
 > 394				nfct_seqadj_ext_add(ct);
   395			pr_debug("ftp: Conntrackinfo = %u\n", ctinfo);
   396			return NF_ACCEPT;
   397		}
   398	
   399		if (unlikely(skb_linearize(skb)))
   400			return NF_DROP;
   401	
   402		th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
   403		if (th == NULL)
   404			return NF_ACCEPT;
   405	
   406		dataoff = protoff + th->doff * 4;
   407		/* No data? */
   408		if (dataoff >= skb->len) {
   409			pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
   410				 skb->len);
   411			return NF_ACCEPT;
   412		}
   413		datalen = skb->len - dataoff;
   414	
   415		/* seqadj (nat) uses ct->lock internally, nf_nat_ftp would cause deadlock */
   416		spin_lock_bh(&nf_ftp_lock);
   417		fb_ptr = skb->data + dataoff;
   418	
   419		ends_in_nl = (fb_ptr[datalen - 1] == '\n');
   420		seq = ntohl(th->seq) + datalen;
   421	
   422		/* Look up to see if we're just after a \n. */
   423		if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
   424			/* We're picking up this, clear flags and let it continue */
   425			if (unlikely(ct_ftp_info->flags[dir] & NF_CT_FTP_SEQ_PICKUP)) {
   426				ct_ftp_info->flags[dir] ^= NF_CT_FTP_SEQ_PICKUP;
   427				goto skip_nl_seq;
   428			}
   429	
   430			/* Now if this ends in \n, update ftp info. */
   431			pr_debug("nf_conntrack_ftp: wrong seq pos %s(%u) or %s(%u)\n",
   432				 ct_ftp_info->seq_aft_nl_num[dir] > 0 ? "" : "(UNSET)",
   433				 ct_ftp_info->seq_aft_nl[dir][0],
   434				 ct_ftp_info->seq_aft_nl_num[dir] > 1 ? "" : "(UNSET)",
   435				 ct_ftp_info->seq_aft_nl[dir][1]);
   436			ret = NF_ACCEPT;
   437			goto out_update_nl;
   438		}
   439	
   440	skip_nl_seq:
   441		/* Initialize IP/IPv6 addr to expected address (it's not mentioned
   442		   in EPSV responses) */
   443		cmd.l3num = nf_ct_l3num(ct);
   444		memcpy(cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
   445		       sizeof(cmd.u3.all));
   446	
   447		for (i = 0; i < ARRAY_SIZE(search[dir]); i++) {
   448			found = find_pattern(fb_ptr, datalen,
   449					     search[dir][i].pattern,
   450					     search[dir][i].plen,
   451					     search[dir][i].skip,
   452					     search[dir][i].term,
   453					     &matchoff, &matchlen,
   454					     &cmd,
   455					     search[dir][i].getnum);
   456			if (found) break;
   457		}
   458		if (found == -1) {
   459			/* We don't usually drop packets.  After all, this is
   460			   connection tracking, not packet filtering.
   461			   However, it is necessary for accurate tracking in
   462			   this case. */
   463			nf_ct_helper_log(skb, ct, "partial matching of `%s'",
   464				         search[dir][i].pattern);
   465			ret = NF_DROP;
   466			goto out;
   467		} else if (found == 0) { /* No match */
   468			ret = NF_ACCEPT;
   469			goto out_update_nl;
   470		}
   471	
   472		pr_debug("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
   473			 matchlen, fb_ptr + matchoff,
   474			 matchlen, ntohl(th->seq) + matchoff);
   475	
   476		exp = nf_ct_expect_alloc(ct);
   477		if (exp == NULL) {
   478			nf_ct_helper_log(skb, ct, "cannot alloc expectation");
   479			ret = NF_DROP;
   480			goto out;
   481		}
   482	
   483		/* We refer to the reverse direction ("!dir") tuples here,
   484		 * because we're expecting something in the other direction.
   485		 * Doesn't matter unless NAT is happening.  */
   486		daddr = &ct->tuplehash[!dir].tuple.dst.u3;
   487	
   488		/* Update the ftp info */
   489		if ((cmd.l3num == nf_ct_l3num(ct)) &&
   490		    memcmp(&cmd.u3.all, &ct->tuplehash[dir].tuple.src.u3.all,
   491			     sizeof(cmd.u3.all))) {
   492			/* Enrico Scholz's passive FTP to partially RNAT'd ftp
   493			   server: it really wants us to connect to a
   494			   different IP address.  Simply don't record it for
   495			   NAT. */
   496			if (cmd.l3num == PF_INET) {
   497				pr_debug("NOT RECORDING: %pI4 != %pI4\n",
   498					 &cmd.u3.ip,
   499					 &ct->tuplehash[dir].tuple.src.u3.ip);
   500			} else {
   501				pr_debug("NOT RECORDING: %pI6 != %pI6\n",
   502					 cmd.u3.ip6,
   503					 ct->tuplehash[dir].tuple.src.u3.ip6);
   504			}
   505	
   506			/* Thanks to Cristiano Lincoln Mattos
   507			   <lincoln@cesar.org.br> for reporting this potential
   508			   problem (DMZ machines opening holes to internal
   509			   networks, or the packet filter itself). */
   510			if (!loose) {
   511				ret = NF_ACCEPT;
   512				goto out_put_expect;
   513			}
   514			daddr = &cmd.u3;
   515		}
   516	
   517		nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, cmd.l3num,
   518				  &ct->tuplehash[!dir].tuple.src.u3, daddr,
   519				  IPPROTO_TCP, NULL, &cmd.u.tcp.port);
   520	
   521		/* Now, NAT might want to mangle the packet, and register the
   522		 * (possibly changed) expectation itself. */
   523		nf_nat_ftp = rcu_dereference(nf_nat_ftp_hook);
   524		if (nf_nat_ftp && ct->status & IPS_NAT_MASK)
   525			ret = nf_nat_ftp(skb, ctinfo, search[dir][i].ftptype,
   526					 protoff, matchoff, matchlen, exp);
   527		else {
   528			/* Can't expect this?  Best to drop packet now. */
   529			if (nf_ct_expect_related(exp, 0) != 0) {
   530				nf_ct_helper_log(skb, ct, "cannot add expectation");
   531				ret = NF_DROP;
   532			} else
   533				ret = NF_ACCEPT;
   534		}
   535	
   536	out_put_expect:
   537		nf_ct_expect_put(exp);
   538	
   539	out_update_nl:
   540		/* Now if this ends in \n, update ftp info.  Seq may have been
   541		 * adjusted by NAT code. */
   542		if (ends_in_nl)
   543			update_nl_seq(ct, seq, ct_ftp_info, dir, skb);
   544	 out:
   545		spin_unlock_bh(&nf_ftp_lock);
   546		return ret;
   547	}
   548	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
