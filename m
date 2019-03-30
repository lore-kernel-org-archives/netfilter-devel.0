Return-Path: <SRS0=fRNh=SB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE10C43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Mar 2019 04:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9ACB2184C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Mar 2019 04:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfC3E4o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Mar 2019 00:56:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:7559 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfC3E4o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Mar 2019 00:56:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Mar 2019 21:56:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,287,1549958400"; 
   d="scan'208";a="131463842"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 29 Mar 2019 21:56:42 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hA62q-000B3j-UG; Sat, 30 Mar 2019 12:56:40 +0800
Date:   Sat, 30 Mar 2019 12:56:05 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild-all@01.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [nf-next:nft-bridge5 5/8] net/ipv6/ip6_output.c:755:16: sparse:
 Using plain integer as NULL pointer
Message-ID: <201903301248.YMBSPiPp%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git nft-bridge5
head:   c8d511967c8897a2191b5e9c8695869d2af44bda
commit: 3553d2535f25f4593ef29d81e6d18a5ee16d1171 [5/8] net: ipv6: split large skbuff into fragments infrastructure
reproduce:
        # apt-get install sparse
        git checkout 3553d2535f25f4593ef29d81e6d18a5ee16d1171
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

>> net/ipv6/ip6_output.c:755:16: sparse: Using plain integer as NULL pointer
   net/ipv6/ip6_output.c:1379:24: sparse: expression using sizeof(void)
   net/ipv6/ip6_output.c:1472:44: sparse: expression using sizeof(void)
   net/ipv6/ip6_output.c:1611:32: sparse: expression using sizeof(void)
   net/ipv6/ip6_output.c:1611:32: sparse: expression using sizeof(void)

vim +755 net/ipv6/ip6_output.c

   682	
   683	struct sk_buff *ip6_frag_next(struct sk_buff *skb, struct ip6_frag_state *state)
   684	{
   685		u8 *prevhdr = state->prevhdr, *fragnexthdr_offset;
   686		struct sk_buff *frag;
   687		struct frag_hdr *fh;
   688		unsigned int len;
   689	
   690		len = state->left;
   691		/* IF: it doesn't fit, use 'mtu' - the data space left */
   692		if (len > state->mtu)
   693			len = state->mtu;
   694		/* IF: we are not sending up to and including the packet end
   695		   then align the next start on an eight byte boundary */
   696		if (len < state->left)
   697			len &= ~7;
   698	
   699		/* Allocate buffer */
   700		frag = alloc_skb(len + state->hlen + sizeof(struct frag_hdr) +
   701				 state->hroom + state->troom, GFP_ATOMIC);
   702		if (!frag)
   703			return ERR_PTR(-ENOMEM);
   704	
   705		/*
   706		 *	Set up data on packet
   707		 */
   708	
   709		ip6_copy_metadata(frag, skb);
   710		skb_reserve(frag, state->hroom);
   711		skb_put(frag, len + state->hlen + sizeof(struct frag_hdr));
   712		skb_reset_network_header(frag);
   713		fh = (struct frag_hdr *)(skb_network_header(frag) + state->hlen);
   714		frag->transport_header = (frag->network_header + state->hlen +
   715					  sizeof(struct frag_hdr));
   716	
   717		/*
   718		 *	Charge the memory for the fragment to any owner
   719		 *	it might possess
   720		 */
   721		if (skb->sk)
   722			skb_set_owner_w(frag, skb->sk);
   723	
   724		/*
   725		 *	Copy the packet header into the new buffer.
   726		 */
   727		skb_copy_from_linear_data(skb, skb_network_header(frag), state->hlen);
   728	
   729		fragnexthdr_offset = skb_network_header(frag);
   730		fragnexthdr_offset += prevhdr - skb_network_header(skb);
   731		*fragnexthdr_offset = NEXTHDR_FRAGMENT;
   732	
   733		/*
   734		 *	Build fragment header.
   735		 */
   736		fh->nexthdr = state->nexthdr;
   737		fh->reserved = 0;
   738		fh->identification = state->frag_id;
   739	
   740		/*
   741		 *	Copy a block of the IP datagram.
   742		 */
   743		BUG_ON(skb_copy_bits(skb, state->ptr, skb_transport_header(frag),
   744				     len));
   745		state->left -= len;
   746	
   747		fh->frag_off = htons(state->offset);
   748		if (state->left > 0)
   749			fh->frag_off |= htons(IP6_MF);
   750		ipv6_hdr(frag)->payload_len = htons(frag->len - sizeof(struct ipv6hdr));
   751	
   752		state->ptr += len;
   753		state->offset += len;
   754	
 > 755		return 0;
   756	}
   757	EXPORT_SYMBOL(ip6_frag_next);
   758	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
