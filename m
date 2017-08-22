From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/6] Remove more global variables
Date: Tue, 22 Aug 2017 19:05:05 +0200
Message-ID: <1503421511-17814-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbdHVRF1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:05:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16877D1622
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06AC4A8241
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2017 19:05:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains more updates to prepare the introduction of
libnftables, by placing global variables into context structures.

This series applies on top of Phil's "[nft] Keep cache in struct nft_ctx":

	http://patchwork.ozlabs.org/patch/804410/

Pablo Neira Ayuso (6):
  src: add include_paths to struct nft_ctx
  src: add maximum number of parser errors to struct nft_ctx
  src: remove ifdef DEBUG pollution
  src: add struct mnl_ctx
  mnl: pass struct netlink_ctx to mnl_nft_socket_sendmsg()
  src: add debugging mask to context structure

 configure.ac              |   4 +-
 include/erec.h            |   6 +-
 include/expression.h      |   3 +-
 include/mnl.h             |   9 ++-
 include/netlink.h         |  18 ++++--
 include/nftables.h        |   8 +--
 include/parser.h          |   8 ++-
 include/proto.h           |   5 +-
 include/rule.h            |   4 +-
 include/utils.h           |  12 ----
 src/cli.c                 |   5 +-
 src/erec.c                |   9 +--
 src/evaluate.c            |  51 ++++++++-------
 src/main.c                |  42 ++++++------
 src/mnl.c                 | 160 +++++++++++++++++++++++++++++-----------------
 src/netlink.c             |  86 +++++++++++--------------
 src/netlink_delinearize.c |   3 +-
 src/netlink_linearize.c   |   2 +-
 src/parser_bison.y        |  21 +++---
 src/proto.c               |  16 +++--
 src/rule.c                |  23 ++++---
 src/scanner.l             |  10 +--
 src/segtree.c             |  30 +++++----
 23 files changed, 293 insertions(+), 242 deletions(-)

-- 
2.1.4


