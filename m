Return-Path: <SRS0=fWn+=7S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8867AC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jun 2020 11:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61AF6206E6
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jun 2020 11:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgFELj6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jun 2020 07:39:58 -0400
Received: from correo.us.es ([193.147.175.20]:44878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgFELj5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jun 2020 07:39:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C531F23B4
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2020 13:39:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A453DA84D
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Jun 2020 13:39:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 479A6DA84F; Fri,  5 Jun 2020 13:39:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AADCDA722;
        Fri,  5 Jun 2020 13:39:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Jun 2020 13:39:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E37C742EE38E;
        Fri,  5 Jun 2020 13:39:50 +0200 (CEST)
Date:   Fri, 5 Jun 2020 13:39:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] libnftnl 1.1.7 release
Message-ID: <20200605113950.GA8489@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.1.7

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Have fun.

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="changes-libnftnl-1.1.7.txt"

Pablo Neira Ayuso (5):
      udata: add NFTNL_UDATA_SET_DATA_INTERVAL
      expr: objref: add nftnl_expr_objref_free() to release object name
      expr: dynset: release stateful expression from .free path
      flowtable: relax logic to build NFTA_FLOWTABLE_HOOK
      build: libnftnl 1.1.7 release


--9amGYk9869ThD9tj--
