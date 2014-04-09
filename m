From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH v2 0/2] New features in nft-parsing-test
Date: Wed,  9 Apr 2014 17:03:43 +0200
Message-ID: <cover.1397048551.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63717 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933204AbaDIPD4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:03:56 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so9079061wiv.4
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 08:03:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset contains new features in nft-parsing-test:

* Add the following command-line arguments:

-u/--update <directory>      Update test files from <directory>.
-f/--file <file>             Check test file <file>\n"

[Changes in v2:]
* Delete 'ruleset: Add an end of line in the exit of ruleset.' patch of
this patchset.


Ana Rey (2):
  tests: New tools to uptade xml and json testfiles.
  tests: Add support to check a json or xml testfile.

 tests/nft-parsing-test.c | 88 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 6 deletions(-)

-- 
1.9.0

