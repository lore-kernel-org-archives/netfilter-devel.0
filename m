From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 0/4] src: chain: Do not print unset values in json and xml
Date: Mon, 30 Jun 2014 13:50:04 +0200
Message-ID: <1404129008-29564-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:39343 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaF3LuY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:50:24 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so8041291wes.11
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 04:50:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In v1, this patchset contains the following patchs:

"Ana Rey (6):
  src: chain: Free memory in the same function that is reserved
  src: chain: Use nft_rule_expr_set_* in the xml parsing code
  src: chain: add set, unset, get, parse and build payload
    implementation for use value
  src: chain: Do not print unset values in xml
  src: chain: Rename variables in nft_jansson_parse_chain functions
  src: chain: Do not print unser values in json
"

I resend a v2 version of four of these six patches. The main change is in
"src: chain: Add all support of use attribute" patch
[ in v1 was "src: chain: add set, unset, get, parse and build payload implementation for use value"]

In this patch, I add a xml support for 'use' attribute that I did not
add in v1.


[in v1:]
This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:

*  src: chain: Free memory in the same function that is reserved
*  src: chain: Use nft_rule_expr_set_* in the xml parsing code
*  src: chain: Rename variables in nft_jansson_parse_chain functions

Moreover, I add some implementation for use valee.


Ana Rey (4):
  src: chain: Add all support of use attribute
  src: chain: Do not print unset values in xml
  src: chain: Rename variables in nft_jansson_parse_chain functions
  src: chain: Do not print unser values in json

 src/chain.c | 335 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 201 insertions(+), 134 deletions(-)

-- 
2.0.0

