From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 0/6] Another round of Covscan indicated fixes
Date: Thu, 14 Dec 2017 20:40:19 +0100
Message-ID: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58058 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTkm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:40:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series fixes potential issues identified by a recent Covscan run.

Phil Sutter (6):
  nftnl_data_reg_snprintf: Add a missing break
  src/gen: Remove a pointless call to mnl_nlmsg_get_payload()
  src/object: Avoid returning garbage in nftnl_obj_do_parse()
  src/ruleset: Avoid reading garbage in nftnl_ruleset_cb()
  src/set_elem: Don't return garbage in nftnl_set_elems_parse()
  src/trace: Check return value of mnl_attr_parse_nested()

 src/expr/data_reg.c |  1 +
 src/gen.c           |  4 ++--
 src/object.c        |  2 +-
 src/ruleset.c       | 10 +++++-----
 src/set_elem.c      |  2 +-
 src/trace.c         |  3 ++-
 6 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.13.1

