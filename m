Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36E4C43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 17:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D2D42063A
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 17:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732357AbgDARll (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 13:41:41 -0400
Received: from correo.us.es ([193.147.175.20]:41250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732288AbgDARll (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 13:41:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C508FEB473
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 19:41:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B547B12395B
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 19:41:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9F17123961; Wed,  1 Apr 2020 19:41:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74FEB123958;
        Wed,  1 Apr 2020 19:41:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 19:41:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 56B274301DF4;
        Wed,  1 Apr 2020 19:41:36 +0200 (CEST)
Date:   Wed, 1 Apr 2020 19:41:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnetfilter_conntrack 1.0.8 release
Message-ID: <20200401174136.t7m4jdh5e2a74otf@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="de6u6t7tf7fshjok"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--de6u6t7tf7fshjok
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_conntrack 1.0.8

libnetfilter_conntrack is a userspace library providing a programming
interface (API) to the in-kernel connection tracking state table. This
library is currently used by conntrack-tools among many other
applications.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Happy firewalling.

--de6u6t7tf7fshjok
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnetfilter_conntrack-1.0.8.txt"

Pablo Neira Ayuso (9):
      qa: test_api: skip synproxy attributes in comparator
      src: introduce abi_breakage()
      expect: add missing handling for CTA_EXPECT_* attributes
      src: replace old libnfnetlink parser
      src: replace old libnfnetlink builder
      conntrack: api: use libmnl API to build the netlink headers
      conntrack: support for IPS_OFFLOAD
      expect: parse_mnl: fix gcc compile warning
      libnetfilter_conntrack: bump version to 1.0.8

Phil Sutter (1):
      Rename 'qa' directory to 'tests'


--de6u6t7tf7fshjok--
