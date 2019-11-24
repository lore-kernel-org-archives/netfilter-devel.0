Return-Path: <SRS0=BgG3=ZQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773B3C432C0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 21:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DBB020748
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Nov 2019 21:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKXVHa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Nov 2019 16:07:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:42679 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfKXVHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Nov 2019 16:07:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2019 13:07:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,239,1571727600"; 
   d="scan'208";a="216790846"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 24 Nov 2019 13:07:28 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYz6N-0000Cr-SW; Mon, 25 Nov 2019 05:07:27 +0800
Date:   Mon, 25 Nov 2019 05:07:07 +0800
From:   kbuild test robot <lkp@intel.com>
To:     wenxu@ucloud.cn
Cc:     kbuild-all@lists.01.org, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 3/4] netfilter: nf_flow_table_offload: add
 tunnel match offload support
Message-ID: <201911250455.bB2bCI2E%lkp@intel.com>
References: <1574330056-5377-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574330056-5377-4-git-send-email-wenxu@ucloud.cn>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on nf-next/master]
[also build test WARNING on next-20191122]
[cannot apply to v5.4-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/wenxu-ucloud-cn/netfilter-nf_flow_table_offload-support-tunnel-offload/20191123-192226
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git master
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-36-g9305d48-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> net/netfilter/nf_flow_table_offload.c:71:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] keyid @@    got  [usertype] keyid @@
>> net/netfilter/nf_flow_table_offload.c:71:32: sparse:    expected restricted __be32 [usertype] keyid
   net/netfilter/nf_flow_table_offload.c:71:32: sparse:    got unsigned int
   net/netfilter/nf_flow_table_offload.c:81:44: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] src @@    got  [usertype] src @@
   net/netfilter/nf_flow_table_offload.c:81:44: sparse:    expected restricted __be32 [usertype] src
   net/netfilter/nf_flow_table_offload.c:81:44: sparse:    got unsigned int
   net/netfilter/nf_flow_table_offload.c:83:44: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] dst @@    got  [usertype] dst @@
   net/netfilter/nf_flow_table_offload.c:83:44: sparse:    expected restricted __be32 [usertype] dst
   net/netfilter/nf_flow_table_offload.c:83:44: sparse:    got unsigned int
   net/netfilter/nf_flow_table_offload.c:130:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] src @@    got  [usertype] src @@
   net/netfilter/nf_flow_table_offload.c:130:32: sparse:    expected restricted __be32 [usertype] src
   net/netfilter/nf_flow_table_offload.c:130:32: sparse:    got unsigned int
   net/netfilter/nf_flow_table_offload.c:132:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be32 [usertype] dst @@    got  [usertype] dst @@
   net/netfilter/nf_flow_table_offload.c:132:32: sparse:    expected restricted __be32 [usertype] dst
   net/netfilter/nf_flow_table_offload.c:132:32: sparse:    got unsigned int
   net/netfilter/nf_flow_table_offload.c:137:29: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] n_proto @@    got e] n_proto @@
   net/netfilter/nf_flow_table_offload.c:137:29: sparse:    expected restricted __be16 [usertype] n_proto
   net/netfilter/nf_flow_table_offload.c:137:29: sparse:    got int
   net/netfilter/nf_flow_table_offload.c:142:33: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] flags @@    got _be16 [usertype] flags @@
   net/netfilter/nf_flow_table_offload.c:142:33: sparse:    expected restricted __be16 [usertype] flags
   net/netfilter/nf_flow_table_offload.c:142:33: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:155:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] src @@    got e] src @@
   net/netfilter/nf_flow_table_offload.c:155:22: sparse:    expected restricted __be16 [usertype] src
   net/netfilter/nf_flow_table_offload.c:155:22: sparse:    got int
   net/netfilter/nf_flow_table_offload.c:157:22: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __be16 [usertype] dst @@    got e] dst @@
   net/netfilter/nf_flow_table_offload.c:157:22: sparse:    expected restricted __be16 [usertype] dst
   net/netfilter/nf_flow_table_offload.c:157:22: sparse:    got int
   net/netfilter/nf_flow_table_offload.c:253:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int [usertype] mask @@    got d int [usertype] mask @@
   net/netfilter/nf_flow_table_offload.c:253:20: sparse:    expected unsigned int [usertype] mask
   net/netfilter/nf_flow_table_offload.c:253:20: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:280:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int [usertype] mask @@    got d int [usertype] mask @@
   net/netfilter/nf_flow_table_offload.c:280:20: sparse:    expected unsigned int [usertype] mask
   net/netfilter/nf_flow_table_offload.c:280:20: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:321:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int [usertype] mask @@    got d int [usertype] mask @@
   net/netfilter/nf_flow_table_offload.c:321:20: sparse:    expected unsigned int [usertype] mask
   net/netfilter/nf_flow_table_offload.c:321:20: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:346:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int [usertype] mask @@    got d int [usertype] mask @@
   net/netfilter/nf_flow_table_offload.c:346:20: sparse:    expected unsigned int [usertype] mask
   net/netfilter/nf_flow_table_offload.c:346:20: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:391:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int [usertype] mask @@    got d int [usertype] mask @@
   net/netfilter/nf_flow_table_offload.c:391:20: sparse:    expected unsigned int [usertype] mask
   net/netfilter/nf_flow_table_offload.c:391:20: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:418:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected unsigned int [usertype] mask @@    got d int [usertype] mask @@
   net/netfilter/nf_flow_table_offload.c:418:20: sparse:    expected unsigned int [usertype] mask
   net/netfilter/nf_flow_table_offload.c:418:20: sparse:    got restricted __be32
   net/netfilter/nf_flow_table_offload.c:632:24: sparse: sparse: incorrect type in initializer (different base types) @@    expected restricted __be16 [usertype] proto @@    got e] proto @@
   net/netfilter/nf_flow_table_offload.c:632:24: sparse:    expected restricted __be16 [usertype] proto
   net/netfilter/nf_flow_table_offload.c:632:24: sparse:    got int
   net/netfilter/nf_flow_table_offload.c:659:24: sparse: sparse: incorrect type in initializer (different base types) @@    expected restricted __be16 [usertype] proto @@    got e] proto @@
   net/netfilter/nf_flow_table_offload.c:659:24: sparse:    expected restricted __be16 [usertype] proto
   net/netfilter/nf_flow_table_offload.c:659:24: sparse:    got int
   net/netfilter/nf_flow_table_offload.c:716:24: sparse: sparse: incorrect type in initializer (different base types) @@    expected restricted __be16 [usertype] proto @@    got e] proto @@
   net/netfilter/nf_flow_table_offload.c:716:24: sparse:    expected restricted __be16 [usertype] proto
   net/netfilter/nf_flow_table_offload.c:716:24: sparse:    got int

vim +71 net/netfilter/nf_flow_table_offload.c

    53	
    54	#define NF_FLOW_DISSECTOR(__match, __type, __field)	\
    55		(__match)->dissector.offset[__type] =		\
    56			offsetof(struct nf_flow_key, __field)
    57	
    58	static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
    59					   struct ip_tunnel_info *tun_info)
    60	{
    61		struct nf_flow_key *mask = &match->mask;
    62		struct nf_flow_key *key = &match->key;
    63		unsigned int enc_keys;
    64	
    65		if (!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX))
    66			return;
    67	
    68		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_CONTROL, enc_control);
    69		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
    70		key->enc_key_id.keyid = tunnel_id_to_key32(tun_info->key.tun_id);
  > 71		mask->enc_key_id.keyid = 0xffffffff;
    72		enc_keys = BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
    73			   BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL);
    74	
    75		if (ip_tunnel_info_af(tun_info) == AF_INET) {
    76			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
    77					  enc_ipv4);
    78			key->enc_ipv4.src = tun_info->key.u.ipv4.dst;
    79			key->enc_ipv4.dst = tun_info->key.u.ipv4.src;
    80			if (key->enc_ipv4.src)
    81				mask->enc_ipv4.src = 0xffffffff;
    82			if (key->enc_ipv4.dst)
    83				mask->enc_ipv4.dst = 0xffffffff;
    84			enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS);
    85			key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
    86		} else {
    87			memcpy(&key->enc_ipv6.src, &tun_info->key.u.ipv6.dst,
    88			       sizeof(struct in6_addr));
    89			memcpy(&key->enc_ipv6.dst, &tun_info->key.u.ipv6.src,
    90			       sizeof(struct in6_addr));
    91			if (memcmp(&key->enc_ipv6.src, &in6addr_any,
    92				   sizeof(struct in6_addr)))
    93				memset(&key->enc_ipv6.src, 0xff,
    94				       sizeof(struct in6_addr));
    95			if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
    96				   sizeof(struct in6_addr)))
    97				memset(&key->enc_ipv6.dst, 0xff,
    98				       sizeof(struct in6_addr));
    99			enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
   100			key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
   101		}
   102	
   103		match->dissector.used_keys |= enc_keys;
   104	}
   105	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
