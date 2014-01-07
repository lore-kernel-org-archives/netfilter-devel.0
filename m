From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 0/6] parsing update
Date: Tue, 07 Jan 2014 12:47:09 +0100
Message-ID: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:53921 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751054AbaAGLrV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:47:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements a parsing update for libnftables.

The first two patches implements two minor fixes I found while working
with the nft_*_parse_file() funcs.

The last four patches are related to the file parsing.

Comments are welcome.

PS: I'm sorry, it seems my diffstat is not working properly :-(

---

Arturo Borrero Gonzalez (6):
      mxml: add error reference of the top node
      set_elem: add json parsing to API
      internal: rework parsing symbol logic
      internal: add a selector for parsing ops
      parsing: add interface to parse from file
      tests: update tests with nft_*_parse_file()


 tests/nft-parsing-test.c |  102 +++++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 43 deletions(-)

-- 
Arturo Borrero Gonzalez
