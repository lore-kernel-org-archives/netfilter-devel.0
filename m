Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDF3C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Jan 2021 20:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F37123A57
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Jan 2021 20:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbhAOUyw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 15:54:52 -0500
Received: from correo.us.es ([193.147.175.20]:47828 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAOUyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 15:54:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97A1E6DFC1
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2021 21:53:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87413DA789
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2021 21:53:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7CCA1DA704; Fri, 15 Jan 2021 21:53:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCC4FDA72F;
        Fri, 15 Jan 2021 21:53:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Jan 2021 21:53:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B95B742DF561;
        Fri, 15 Jan 2021 21:53:19 +0100 (CET)
Date:   Fri, 15 Jan 2021 21:54:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.1.9 release
Message-ID: <20210115205406.GA19710@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.1.9

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.1.9.txt"

Jeremy Sowden (1):
      bitwise: improve formatting of registers in bitwise dumps.

Pablo Neira Ayuso (5):
      src: add NFTNL_SET_ELEM_EXPRESSIONS
      src: add NFTNL_SET_EXPRESSIONS
      src: add NFTNL_EXPR_DYNSET_EXPRESSIONS
      dynset: add NFTNL_EXPR_DYNSET_FLAGS
      build: libnftnl 1.1.9 release

Phil Sutter (2):
      set_elem: Use nftnl_data_reg_snprintf()
      set_elem: Include key_end data reg in print output


--7AUc2qLy4jB3hD7Z--
