Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA0DC43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 14:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97C3C20719
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 14:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733048AbgDAOe0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 10:34:26 -0400
Received: from correo.us.es ([193.147.175.20]:33000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732978AbgDAOeZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 10:34:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6AEEF25A6
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 16:34:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C45A4132C8C
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 16:34:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4543132CAC; Wed,  1 Apr 2020 16:34:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F445132C8A;
        Wed,  1 Apr 2020 16:34:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 16:34:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 403124301DE1;
        Wed,  1 Apr 2020 16:34:20 +0200 (CEST)
Date:   Wed, 1 Apr 2020 16:34:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.1.6 release
Message-ID: <20200401143419.a3kjyv6jds63zmoz@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ewrmvbtdxalrojej"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ewrmvbtdxalrojej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.1.6

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Happy firewalling.


--ewrmvbtdxalrojej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.1.6.txt"

Brett Mastbergen (1):
      include: Remove buffer.h

Florian Westphal (1):
      expr: meta: add slave device matching

Jeremy Sowden (9):
      Update gitignore.
      bitwise: fix some incorrect indentation.
      bitwise: add helper to print boolean expressions.
      include: update nf_tables.h.
      bitwise: add support for new netlink attributes.
      bitwise: add support for left- and right-shifts.
      tests: bitwise: fix error message.
      include: update nf_tables.h.
      bitwise: add support for passing mask and xor via registers.

Pablo Neira Ayuso (12):
      include: typo in object.h C++ wrapper
      udata: add NFTNL_UDATA_SET_*TYPEOF* definitions
      udata: support for TLV attribute nesting
      src: add nftnl_*_{get,set}_array()
      chain: add NFTNL_CHAIN_FLAGS
      set_elem: missing set and build for NFTNL_SET_ELEM_EXPR
      set: support for NFTNL_SET_EXPR
      expr: masq: revisit _snprintf()
      expr: nat: snprint flags in hexadecimal
      Revert "bitwise: add support for passing mask and xor via registers."
      include: update nf_tables.h.
      build: libnftnl 1.1.6 release

Phil Sutter (7):
      tests: flowtable: Don't check NFTNL_FLOWTABLE_SIZE
      flowtable: Fix memleak in error path of nftnl_flowtable_parse_devs()
      chain: Fix memleak in error path of nftnl_chain_parse_devs()
      flowtable: Correctly check realloc() call
      chain: Correctly check realloc() call
      examples: Replace use of deprecated symbols
      src: Fix for reading garbage in nftnl_chain getters

Stefano Brivio (3):
      include: resync nf_tables.h cache copy
      set: Add support for NFTA_SET_DESC_CONCAT attributes
      set_elem: Introduce support for NFTNL_SET_ELEM_KEY_END


--ewrmvbtdxalrojej--
