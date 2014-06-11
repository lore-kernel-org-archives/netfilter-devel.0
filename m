From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/5] Set: Do not print unset value
Date: Wed, 11 Jun 2014 17:50:45 +0200
Message-ID: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65113 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaFKPvN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:13 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so1400689wib.15
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset do task about does not print unset value in xml and json file
and about refactoring code: "Use nft_rule_expr_set_* in the xml parsing
code" Also, It add test files that is need to be modificated to these patch
and It fixes a leak memory.

Ana Rey (5):
  src: set: Use nft_rule_expr_set_* in the xml parsing code
  src: set: Do not print unset values in xml
  src: set: Do not print unset values in json
  src: set: Free memory in the same function that is reserved.
  tests: xmlfile: Test files without unset child elements in set
    elements

 src/jansson.c                 |  12 +--
 src/set.c                     | 208 +++++++++++++++++++++++++-----------------
 src/set_elem.c                |  50 +++++-----
 tests/xmlfiles/73-set.xml     |   2 +-
 tests/xmlfiles/74-set.xml     |   2 +-
 tests/xmlfiles/75-ruleset.xml |   2 +-
 6 files changed, 158 insertions(+), 118 deletions(-)

-- 
2.0.0

