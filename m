From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 0/4] small updates to documentation
Date: Wed, 14 May 2014 17:36:07 +0200
Message-ID: <20140514153146.25186.58208.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48860 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754280AbaENPgU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2014 11:36:20 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 95B9E51EE9B
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 15:36:18 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qjecnUy520vT for <netfilter-devel@vger.kernel.org>;
	Wed, 14 May 2014 17:36:08 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id B8B1A51ED91
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2014 17:36:08 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements some small updates to the nft documentation.

The nft manpage is a bit outdated.
Also, the first patch is a small fix.

Comments welcome.
---

Arturo Borrero Gonzalez (4):
      doc: fix indendation of examples
      doc: update return code for NFT_EXIT_NONL
      doc: document export op
      doc: document monitor op


 doc/nft.xml |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 3 deletions(-)

-- 
Arturo Borrero Gonzalez
