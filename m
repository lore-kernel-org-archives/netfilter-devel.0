Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8369C3A59D
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 11:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F3320844
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 11:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfHSLDg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 07:03:36 -0400
Received: from correo.us.es ([193.147.175.20]:34800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbfHSLDg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 07:03:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0277080767
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 13:03:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7C24335E
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 13:03:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD571DA840; Mon, 19 Aug 2019 13:03:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79927D2B1F;
        Mon, 19 Aug 2019 13:03:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Aug 2019 13:03:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.181.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2ED504265A2F;
        Mon, 19 Aug 2019 13:03:31 +0200 (CEST)
Date:   Mon, 19 Aug 2019 13:03:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.1.4 release
Message-ID: <20190819110328.vnwmmox5ymabneib@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="twaeaue3tdaywezh"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--twaeaue3tdaywezh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.1.4

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This
library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Happy firewalling.

--twaeaue3tdaywezh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-libnftnl-1.1.4.txt"
Content-Transfer-Encoding: 8bit

Brett Mastbergen (1):
      src: Add ct id support

Fernando Fernandez Mancera (1):
      src: add synproxy support

Florian Westphal (1):
      udata: fix sigbus crash on sparc

Laura Garcia Liebana (1):
      src: enable set expiration date for set elements

Pablo Neira Ayuso (2):
      include: resync nf_tables.h cache copy
      build: libnftnl 1.1.4 release

Phil Sutter (1):
      expr: meta: Make NFT_META_{I,O}IFKIND known

Stephen Suryaputra (1):
      src: add support for matching IPv4 options

Stéphane Veyret (2):
      src: add ct expectation support
      examples: add ct expectation examples

Thomas Petazzoni (1):
      Add Requires.private field to libnftnl.pc

wenxu (1):
      expr: meta: Make NFT_META_BRI_IIF{VPROTO, PVID} known


--twaeaue3tdaywezh--
