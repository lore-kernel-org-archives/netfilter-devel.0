From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables] Examples of XML output
Date: Mon, 11 Feb 2013 23:56:33 +0100
Message-ID: <20130211225529.2489.3521.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pneira@us.es
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36115 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932675Ab3BKXsM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:48:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---

Arturo Borrero (1):
      Added examples of functionality to print XML output of nftables rule/chain/table


 examples/nft-chain-get.c |   17 ++++++++++++-----
 examples/nft-rule-get.c  |   12 ++++++++++--
 examples/nft-table-get.c |   25 +++++++++++++++++++++++--
 src/expr/match.c         |    2 --
 4 files changed, 45 insertions(+), 11 deletions(-)

-- 
