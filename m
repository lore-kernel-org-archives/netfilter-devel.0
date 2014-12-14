From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/4] nft updates
Date: Sun, 14 Dec 2014 18:00:59 +0100
Message-ID: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45108 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaLNQ6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:58:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Small oneliner fix to set byteorder in string_type. And updates for the
nft-test.py script.

If no objections, I'll push this to master before the upcoming 0.4
release.

Pablo Neira Ayuso (4):
  datatype: missing byteorder in string_type
  tests: regression: fix wrong number of test files
  tests: regression: simplify run_test_file() in case `-e' is used
  tests: regression: log.t: this works for bridge and arp since 3.17

 src/datatype.c               |    1 +
 tests/regression/any/log.t   |    9 ++++-----
 tests/regression/nft-test.py |   19 +++----------------
 3 files changed, 8 insertions(+), 21 deletions(-)

-- 
1.7.10.4

