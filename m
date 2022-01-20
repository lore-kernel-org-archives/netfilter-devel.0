Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F1EC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 00:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiATAEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:04:09 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37188 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiATAEI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 19:04:08 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 43BC460027;
        Thu, 20 Jan 2022 01:01:10 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH libnftnl 0/3] add description infrastructure
Date:   Thu, 20 Jan 2022 01:03:59 +0100
Message-Id: <20220120000402.916332-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

This is my proposal to address the snprintf data printing depending on
the arch. The idea is to add description objects that can be used to
build the userdata area as well as to parse the userdata to create the
description object.

This is revisiting 6e48df5329ea ("src: add "typeof" build/parse/print
support") in nftables which adds build and parse userdata callbacks to
expression in libnftables. My proposal is to move this to libnftnl.

This allows to consolidate codebase to address two different usecases:
- you can pass the description object to the snprintf function.
- it provides helpers to build and to parse the userdata area. The
  userdata TLV attributes do not need to be exposed through
  libnftnl/udata.h anymore, instead users can just rely on these helper
  functions.

The userdata area has been extended with new attributes, but it is still
incomplete since it does not allow to represent a concatenation.

Note that this will also allow us to deprecate NFTA_SET_DATA_TYPE at
some point (this netlink attribute represents a concatenation using 6
bits of the 32-bit integer, hence limiting concatenations to 5
components at this stage).

I'm afraid we'll also have to keep the existing userdata attributes
added by 6e48df5329ea in nftables for a little while (at least the
parser functions), so nftables does not break on updates since my
userdata TLV coming in this patchset for libnftnl is different than the
one available at 6e48df5329ea.

Please also note that nftables needs to be updated to use this
infrastructure.

My proposal follows a longer route but it will allow to addressing a
number of existing shortcomings in the set infrastrcture.

This is compile-tested only.

Pablo Neira Ayuso (3):
  desc: add expression description
  desc: add datatype description
  desc: add set description

 include/Makefile.am          |   1 +
 include/desc.h               |  50 +++
 include/expr_ops.h           |  11 +
 include/internal.h           |   1 +
 include/libnftnl/Makefile.am |   1 +
 include/libnftnl/desc.h      | 107 +++++++
 include/libnftnl/udata.h     |  18 +-
 src/Makefile.am              |   1 +
 src/desc.c                   | 598 +++++++++++++++++++++++++++++++++++
 src/expr/payload.c           |  81 +++++
 src/expr_ops.c               |  13 +
 11 files changed, 875 insertions(+), 7 deletions(-)
 create mode 100644 include/desc.h
 create mode 100644 include/libnftnl/desc.h
 create mode 100644 src/desc.c

-- 
2.30.2

