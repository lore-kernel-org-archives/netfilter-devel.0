From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/6] src: chain: Do not print unset values in json and xml
Date: Thu, 26 Jun 2014 18:38:54 +0200
Message-ID: <1403800740-10572-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:53384 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaFZQjS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:39:18 -0400
Received: by mail-we0-f176.google.com with SMTP id u56so3852354wes.21
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 09:39:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:

*  src: chain: Free memory in the same function that is reserved
*  src: chain: Use nft_rule_expr_set_* in the xml parsing code
*  src: chain: Rename variables in nft_jansson_parse_chain functions

Moreover, I add some implementation for use valee.

*** BLURB HERE ***

Ana Rey (6):
  src: chain: Free memory in the same function that is reserved
  src: chain: Use nft_rule_expr_set_* in the xml parsing code
  src: chain: add set, unset, get, parse and build payload
    implementation for use value
  src: chain: Do not print unset values in xml
  src: chain: Rename variables in nft_jansson_parse_chain functions
  src: chain: Do not print unser values in json

 src/chain.c | 364 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 203 insertions(+), 161 deletions(-)

-- 
2.0.0

