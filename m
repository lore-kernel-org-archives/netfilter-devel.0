From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 0/3] New features in nft-parsing-test
Date: Wed,  9 Apr 2014 10:53:58 +0200
Message-ID: <cover.1397032579.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56011 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDIIyN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:54:13 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so2776332wib.10
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 01:54:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patchset contains new features in nft-parsing-test:

* Add the following command-line arguments:

-u/--update <directory>      Update test files from <directory>.
-f/--file <file>             Check test file <file>\n"

* Add an end of line in the exit of ruleset. It is necessary to write the
new generated testfiles.

Ana Rey (3):
  ruleset: Add an end of line in the exit of ruleset.
  tests: New tools to uptade xml and json testfiles.
  tests: Add support to check a json or xml testfile.

 src/ruleset.c            |  2 +-
 tests/nft-parsing-test.c | 88 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 83 insertions(+), 7 deletions(-)

-- 
1.9.0

