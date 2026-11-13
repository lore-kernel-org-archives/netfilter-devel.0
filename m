Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590559;
	b=DHbcsB1A+m58O+Twesvr1Xox3MqYj+lMkb+LVbzQNQZrW2Yrcn11wpZf/IfcMktXBxHc
	 iRIUz1HC/CfRsKNyV6as5fhcnlT/Gz2CUd95qc3iVuFe1DUo2DwP5SNqmlv1T6bvr0eGW
	 6f/nNypF3B5npPvMYYv93Vyv9ESbkMIjHSz12qMeSEH2NvSL8VfXS8CUZjM13YXjxDvyx
	 7BELbZL0RvH9sWyafQ4bCi37qHJwkYsJFTYauTN0B2aLvYBYaQ7FDAOOB6qZZzjt2TIaI
	 3zPg06tFJTwKUuVrTxVFgcMGy0TBspL3fttLWANimAEaauOSzAFA2fxca3xs/ZoX0XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590559;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:User-Agent;
	bh=Q3PChlE1j7qFOItoGhggcAcUQEsm7d5W4hq/gH2gOQY=;
	b=OS8ixLntZlZXTFhGVD9v7EyYTE+7fT9mDDhCGzPR3Mj9AdZiHch3myPx5YkvFEI8nMOr
	 YAcEtMjCC0dvnCj2M2t3j/VT4RWNl4mVjSaM36jIi/4JMo3LNH7w7h6xdEV2HPzfSjEFZ
	 Y6pgK7dqlGIsslRWxysGe/JHAREwL0bU+Etqxkx6Mv6r3xytGUgYCYPs8DaBUgO903MPT
	 3a2/xyLczD6mbB29AZzzeX2HFcyFr8Mg4GuCaDqhgy+iWmyogR6ZgZp47TtvWoolxTXIZ
	 Aq/FMv77aXkzqeRSsv9SApO6a/tbnRpWkm/MHvH70li7jTgg6KAaxuXLUKn4cMs4OCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YlgKgEcc;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAB6608436D
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 17:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAAB6608436D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=YlgKgEcc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794590558; x=1826126558;
  h=date:from:to:cc:subject:message-id;
  bh=HUS+UC/YrarOD0jFQeMuNxWQobvI/+VrFWeSb7c5Kgs=;
  b=YlgKgEccZUhz9xcwjqlFsv30yr6Ri/bUZxNNMQeR5NbzSa4/QffP5T8Q
   Uz2yFU0bbTawbWIaL0w46wgNp9lAYneXRpidZJpTk8fj7Ijd7d+eeAHEK
   OEAPeOTov4wNPpWrYj810mifNW8xRNmn8i/oHpxYG2BQSAfn4NkukpMU3
   qhLpPyQix+UzMuPE+zaWEXVWGTkKZb/P4Zg0Zm8iqW3GPv6V2XlysESgm
   5xPf7eto8BXIUicI/jFPL35JeNyCYGuqij9T+FB0WNpplhaL/IyKMuD2U
   /1ZqnadCkiwQpTC13aUip9m/AaNZroCI5vmuOvcZ9o8lmlpTh+R3odsdO
   w==;
X-CSE-ConnectionGUID: 7eewNIqYT/WgZ3A6QDsraQ==
X-CSE-MsgGUID: TYm2xIi9QWW/Bh28iVCYog==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3396320"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3396320"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 09:22:37 -0800
X-CSE-ConnectionGUID: goSH8VT7TZqB9Ep0vwEevg==
X-CSE-MsgGUID: 865uJTiFQK2mobHk4S5f+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="8884412"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 13 Nov 2026 09:22:34 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRuyt-000000013Rl-4619;
	Fri, 13 Nov 2026 17:22:31 +0000
Date: Sat, 14 Nov 2026 01:21:33 +0800
From: kernel test robot <lkp@intel.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [netfilter-nf:for-netdev-nf-26-11-13 27/27]
 net/netfilter/ipvs/ip_vs_conn.c:1060:35: error: 'ip_vs_null_xmit_v6'
 undeclared; did you mean 'ip_vs_null_xmit'?
Message-ID: <202611140155.JJLOxzRS-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git for-netdev-nf-26-11-13
head:   937b060406a547e4d931525e600540726ea26532
commit: 937b060406a547e4d931525e600540726ea26532 [27/27] ipvs: pass correct sk to update_pmtu and on tunneling
config: x86_64-buildonly-randconfig-1003-20261113 (https://download.01.org/0day-ci/archive/20261114/202611140155.JJLOxzRS-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261114/202611140155.JJLOxzRS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611140155.JJLOxzRS-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/ipvs/ip_vs_conn.c: In function 'ip_vs_bind_xmit':
>> net/netfilter/ipvs/ip_vs_conn.c:1060:35: error: 'ip_vs_null_xmit_v6' undeclared (first use in this function); did you mean 'ip_vs_null_xmit'?
    1060 |                 cp->packet_xmit = ip_vs_null_xmit_v6;
         |                                   ^~~~~~~~~~~~~~~~~~
         |                                   ip_vs_null_xmit
   net/netfilter/ipvs/ip_vs_conn.c:1060:35: note: each undeclared identifier is reported only once for each function it appears in


vim +1060 net/netfilter/ipvs/ip_vs_conn.c

  1034	
  1035	/*
  1036	 *	Bind a connection entry with the corresponding packet_xmit.
  1037	 *	Called by ip_vs_conn_new.
  1038	 */
  1039	static inline void ip_vs_bind_xmit(struct ip_vs_conn *cp)
  1040	{
  1041		switch (IP_VS_FWD_METHOD(cp)) {
  1042		case IP_VS_CONN_F_MASQ:
  1043			cp->packet_xmit = ip_vs_nat_xmit;
  1044			break;
  1045	
  1046		case IP_VS_CONN_F_TUNNEL:
  1047	#ifdef CONFIG_IP_VS_IPV6
  1048			if (cp->daf == AF_INET6)
  1049				cp->packet_xmit = ip_vs_tunnel_xmit_v6;
  1050			else
  1051	#endif
  1052				cp->packet_xmit = ip_vs_tunnel_xmit;
  1053			break;
  1054	
  1055		case IP_VS_CONN_F_DROUTE:
  1056			cp->packet_xmit = ip_vs_dr_xmit;
  1057			break;
  1058	
  1059		case IP_VS_CONN_F_LOCALNODE:
> 1060			cp->packet_xmit = ip_vs_null_xmit_v6;
  1061			break;
  1062	
  1063		case IP_VS_CONN_F_BYPASS:
  1064			cp->packet_xmit = ip_vs_bypass_xmit;
  1065			break;
  1066		}
  1067	}
  1068	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
