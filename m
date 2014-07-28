From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 0/4] Changes in nft byteorder conversions
Date: Mon, 28 Jul 2014 13:51:47 +0200
Message-ID: <1406548311-31354-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:35664 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaG1Lv6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:51:58 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so7274245wes.38
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2014 04:51:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, when we have added a rule, we have done some byteorder conversions
in the parser step, evaluation step and linealize step. For that, in some case
if we try to add rules, we have done wrong byteorder conversions and we have had
matching problems or when we have tried to show the rules that we have added
we have showed rules with values in wrong byteorder. We have had too this
problems when we have used sets or range.

This series of patches changes the policy for doing byteorder conversions in our
rules. We are going to do all the conversions in two steps, parser and
evaluation. That changes remove consecutive byteorder conversions, make more
easy administrate the byteorder conversions for adding and for showing rules and
fix some case that we don't update correctly the context for using values
without correctly byteorder conversions. This patches enables to use ranges and
sets with the rules without problems.

Comments are welcome.

Alvaro Neira Ayuso (4):
  payload: fix update context with wrong byteorder
  src: fix byteorder conversions in simple values
  src: fix byteorder conversions in range values
  src: fix byteorder conversions in sets

 include/gmputil.h         |    1 +
 include/netlink.h         |    3 +--
 src/datatype.c            |    8 ++++++--
 src/evaluate.c            |   48 +++++++++++++++++++++++++++++---------------
 src/expression.c          |    8 ++++++--
 src/gmputil.c             |   15 +++++++++++++-
 src/netlink.c             |   13 ++++++++----
 src/netlink_delinearize.c |   49 +++++++++++++++++++++++++++++++++++++++++----
 src/netlink_linearize.c   |   10 ++++-----
 src/payload.c             |   10 ++++++---
 10 files changed, 126 insertions(+), 39 deletions(-)

-- 
1.7.10.4

