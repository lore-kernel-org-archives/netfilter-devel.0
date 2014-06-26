From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/5] Do not print unset values in xml and json
Date: Thu, 26 Jun 2014 19:08:36 +0200
Message-ID: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:38564 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaFZRI4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:08:56 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so4056555wev.6
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2014 10:08:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset does tasks about does not print unset value in xml and json file
and about refactoring code:

* src: table: Free memory in the same function that is reserved
* src: table: Use nft_table_attr_set_* in the xml functions
* src: table: Add set, unset and parse implementation for use value

 Moreover, I add some implementations for use value.

Ana Rey (5):
  src: table: Free memory in the same function that is reserved
  src: table: Use nft_table_attr_set_* in the xml functions
  src: table: Add set, unset and parse implementation for use value
  src: table: Do not print unset values in xml file
  src: table: Do not print unset values in json file

 src/table.c | 144 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 92 insertions(+), 52 deletions(-)

-- 
2.0.0

