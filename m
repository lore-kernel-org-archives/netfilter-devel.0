Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97D4C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 12:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A78CF20883
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 12:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfE0MDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 08:03:51 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:44077 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfE0MDv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 08:03:51 -0400
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hVELz-0007oo-6J; Mon, 27 May 2019 14:03:49 +0200
Date:   Mon, 27 May 2019 14:03:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.1.3 release
Message-ID: <20190527120346.gz2dlmx2gstgkyld@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2qu4b5sux64qwnql"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--2qu4b5sux64qwnql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.1.3

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This
library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Happy firewalling.


--2qu4b5sux64qwnql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.1.3.txt"

Fernando Fernandez Mancera (1):
      expr: osf: add version option support

Florian Westphal (2):
      set_elem: close a padding hole
      src: libnftnl: export genid functions again

Laura Garcia Liebana (2):
      Revert "expr: add map lookups for numgen statements"
      Revert "expr: add map lookups for hash statements"

Pablo Neira Ayuso (2):
      udata: add NFTNL_UDATA_* definitions
      build: libnftnl 1.1.3 release

Phil Sutter (12):
      chain: Support per chain rules list
      chain: Add lookup functions for chain list and rules in chain
      chain: Hash chain list by name
      object: Avoid obj_ops array overrun
      flowtable: Add missing break
      flowtable: Fix use after free in two spots
      flowtable: Fix memleak in nftnl_flowtable_parse_devs()
      flowtable: Fix for reading garbage
      src: chain: Add missing nftnl_chain_rule_del()
      src: chain: Fix nftnl_chain_rule_insert_at()
      src: rule: Support NFTA_RULE_POSITION_ID attribute
      include: Remove redundant declaration of nftnl_gen_nlmsg_parse()


--2qu4b5sux64qwnql--
