Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D760AC2B9F8
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 11:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B059E61413
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 May 2021 11:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhEYL5m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 May 2021 07:57:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60772 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhEYL5l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 May 2021 07:57:41 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D2CFE641DC;
        Tue, 25 May 2021 13:55:07 +0200 (CEST)
Date:   Tue, 25 May 2021 13:56:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.0 release
Message-ID: <20210525115605.GA16518@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.0

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

See ChangeLog that comes attached to this email for more details.

You can download it from:

http://www.netfilter.org/projects/libnftnl/downloads.html
https://www.netfilter.org/pub/libnftnl/

Have fun!

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.2.0.txt"

Pablo Neira Ayuso (4):
      table: add table owner support
      src: incorrect header refers to GPLv2 only
      expr: socket: add cgroups v2 support
      build: libnftnl 1.2.0 release

Phil Sutter (16):
      expr/socket: Kill dead code
      expr/tunnel: Kill dead code
      expr/xfrm: Kill dead code
      rule: Avoid printing trailing spaces
      expr/{masq,nat}: Don't print unused regs
      set_elem: Fix printing of verdict map elements
      expr: Fix snprintf buffer length updates
      obj/ct_expect: Fix snprintf buffer length updates
      obj/ct_timeout: Fix snprintf buffer length updates
      object: Fix for wrong parameter passed to snprintf callback
      expr: Check output type once and for all
      expr/data_reg: Drop output_format parameter
      obj: Drop type parameter from snprintf callback
      Drop pointless local variable in snprintf callbacks
      Get rid of single option switch statements
      ruleset: Eliminate tag and separator helpers


--GvXjxJ+pjyke8COw--
