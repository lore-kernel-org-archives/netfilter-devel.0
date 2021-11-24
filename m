Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB74C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhKXR0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbhKXR0T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:19 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA430C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:23:09 -0800 (PST)
Received: from localhost ([::1]:44832 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvz9-00015w-Qd; Wed, 24 Nov 2021 18:23:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 0/7] Stabilize debug output on different endian systems
Date:   Wed, 24 Nov 2021 18:22:35 +0100
Message-Id: <20211124172242.11402-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 adds byteorder information to expressions, making it possible to
print expressions' data in correct byteorder.

For set elements, more effort is required. To accomplish this, patches 2
and 3 introduce new set meta data, patches 4 and 5 extend data reg
printing to make use of this extended data and patches 6 and 7 extend
the API to allow for external input of the data when printing elements.

Due to patches 6 and 7, patches 2 and 3 are not necessary for the
following series of nftables patches. Yet they are left for the sake of
completeness and the fact that libnftnl users might want to print set
elements along with their set and therefore define meta data via the
attributes introduced in patches 2 and 3.

Pablo Neira Ayuso (1):
  src: add infrastructure to infer byteorder from keys

Phil Sutter (6):
  set: Introduce NFTNL_SET_DESC_BYTEORDER
  set: Introduce NFTNL_SET_DESC_CONCAT_DATA
  data_reg: Support varying byteorder in concat data
  data_reg: Respect each value's size
  include: Introduce and publish struct nftnl_set_desc
  set: Introduce nftnl_set_elem_snprintf_desc()

 include/common.h       | 29 +++++++++++++++++++
 include/data_reg.h     | 10 ++++++-
 include/expr.h         |  2 +-
 include/expr_ops.h     |  2 ++
 include/libnftnl/set.h | 16 +++++++++++
 include/set.h          |  7 ++---
 include/set_elem.h     |  3 --
 src/expr.c             | 51 +++++++++++++++++++++++++++++++++
 src/expr/bitwise.c     | 30 ++++++++++++++------
 src/expr/byteorder.c   | 21 ++++++++++++++
 src/expr/cmp.c         | 21 +++++++++++++-
 src/expr/ct.c          | 30 ++++++++++++++++++++
 src/expr/data_reg.c    | 64 +++++++++++++++++++++++++++++++++++++-----
 src/expr/dup.c         | 14 +++++++++
 src/expr/exthdr.c      | 14 +++++++++
 src/expr/fib.c         | 18 ++++++++++++
 src/expr/fwd.c         | 14 +++++++++
 src/expr/immediate.c   | 17 +++++++++--
 src/expr/masq.c        | 16 +++++++++++
 src/expr/meta.c        | 28 ++++++++++++++++++
 src/expr/nat.c         | 22 +++++++++++++++
 src/expr/numgen.c      | 12 ++++++++
 src/expr/osf.c         | 12 ++++++++
 src/expr/payload.c     | 14 +++++++++
 src/expr/queue.c       | 12 ++++++++
 src/expr/range.c       | 11 ++++++--
 src/expr/redir.c       | 16 +++++++++++
 src/expr/rt.c          | 19 +++++++++++++
 src/expr/socket.c      | 12 ++++++++
 src/expr/tproxy.c      | 14 +++++++++
 src/expr/tunnel.c      | 12 ++++++++
 src/expr/xfrm.c        | 18 ++++++++++++
 src/libnftnl.map       |  4 +++
 src/rule.c             |  7 +++++
 src/set.c              | 21 ++++++++++++--
 src/set_elem.c         | 47 +++++++++++++++++++++----------
 36 files changed, 612 insertions(+), 48 deletions(-)

-- 
2.33.0

