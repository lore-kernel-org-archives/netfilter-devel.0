Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F86E7F154
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 11:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjI2LSV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 07:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjI2LSV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 07:18:21 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEF0DE;
        Fri, 29 Sep 2023 04:18:17 -0700 (PDT)
Received: from [78.30.34.192] (port=37622 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qmBVa-008uRk-Vb; Fri, 29 Sep 2023 13:18:13 +0200
Date:   Fri, 29 Sep 2023 13:18:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     lwn@lwn.net, netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] conntrack-tools 1.4.8 release
Message-ID: <ZRaycoBMnOsxHNK8@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="iSyG50L6krH8poFB"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--iSyG50L6krH8poFB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        conntrack-tools 1.4.8

This release contains bugfixes:

- fix spurious EOPNOSUPP and ENOBUFS errors with -U/--update command.
- fix spurious ENOENT -D/--delete.

You can download the new release from:

https://netfilter.org/projects/conntrack-tools/downloads.html#conntrack-tools-1.4.8

To build the code, updated libnetfilter_conntrack 1.0.9 is required:

https://netfilter.org/projects/libnetfilter_conntrack/downloads.html#libnetfilter_conntrack-1.0.9

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--iSyG50L6krH8poFB
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="changes-conntrack-tools-1.4.8.txt"

Jacek Tomasiak (1):
      conntrack: don't override mark when filtering by status

Jeremy Sowden (5):
      conntrack, nfct: fix some typo's
      build: reformat and sort `conntrack_LDADD` and `conntrackd_SOURCES`
      build: stop suppressing warnings for generated sources
      read_config_yy: correct `yyerror` prototype
      read_config_yy: correct arguments passed to `inet_aton`

Pablo Neira Ayuso (8):
      build: conntrack-tools requires libnetfilter_conntrack >= 1.0.9
      conntrack: do not silence EEXIST error, use NLM_F_EXCL
      conntrack: unbreak -U command, use correct family
      conntrack: skip ENOENT when -U/-D finds a stale conntrack entry
      conntrack: do not set on NLM_F_ACK in IPCTNL_MSG_CT_GET requests
      tests/conntrack: add initial stress test for conntrack
      conntrackd: consolidate check for maximum number of channels
      conntrack-tools 1.4.8 release

Phil Sutter (5):
      Makefile: Create LZMA-compressed dist-files
      conntrack: Fix potential array out of bounds access
      conntrack: Fix for unused assignment in do_command_ct()
      conntrack: Fix for unused assignment in ct_save_snprintf()
      conntrack: Sanitize free_tmpl_objects()

Sam James (3):
      build: don't suppress various warnings
      network: Fix -Wstrict-prototypes
      config: Fix -Wimplicit-function-declaration


--iSyG50L6krH8poFB--
