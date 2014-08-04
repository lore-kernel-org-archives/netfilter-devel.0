From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 0/5] Changes in nft byteorder conversions
Date: Mon,  4 Aug 2014 18:00:06 +0200
Message-ID: <1407168011-6424-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38522 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbaHDQAa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:00:30 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so5295352wiw.12
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Aug 2014 09:00:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, if we add a rule, we do some byteorder conversions in the parser,
evaluation and linealize steps. So, if we try to add rules, we do wrong
byteorder conversions. Therefore, we have matching problems or we show
the rules with wrong byteorder. Usually, we have these problems with sets
and ranges.

These series of patches changes the policy for doing byteorder conversions in our
rules. We are going to do all the conversions in two steps, parser and
evaluation. That changes remove consecutive byteorder conversions. Thus, these
patches fixing these problems for adding and for showing rules. Too, fix some
case that we don't update correctly the context for using values without
correctly byteorder conversions. These patches enables to use ranges and sets
with the rules without problems.

Comments are welcome.

Alvaro Neira Ayuso (5):
  payload: fix update context with wrong byteorder
  payload: generate dependency in the correct byteorder
  src: fix byteorder conversions in constant values
  src: fix byteorder conversions in range values
  src: fix byteorder conversions in sets

 include/datatype.h        |    1 +
 include/expression.h      |    2 ++
 include/netlink.h         |    3 +--
 src/datatype.c            |   16 +++++++++++++--
 src/evaluate.c            |   37 ++++++++++++++++++++++++++++-------
 src/expression.c          |   17 ++++++++++++++--
 src/gmputil.c             |    9 +++++++--
 src/netlink.c             |   13 +++++++++----
 src/netlink_delinearize.c |   47 +++++++++++++++++++++++++++++++++++++++++----
 src/netlink_linearize.c   |   10 +++++-----
 src/payload.c             |   10 +++++++---
 src/proto.c               |    2 +-
 12 files changed, 135 insertions(+), 32 deletions(-)

-- 
1.7.10.4

