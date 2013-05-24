From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 0/2] small fixes for libnftables XML
Date: Fri, 24 May 2013 13:28:36 +0200
Message-ID: <20130524112756.13209.37625.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:58199 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885Ab3EXL2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 May 2013 07:28:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements a couple of fixes for libnftables XML.

The versioning attributes for XML is added to provide a future way to easily modify que XML format once libnftables is released.
Casting are for the same data type, thus useless.

---

Arturo Borrero (2):
      src: chain: delete useless castings
      src: xml: add versioning


 include/libnftables/chain.h |    2 ++
 include/libnftables/rule.h  |    2 ++
 include/libnftables/table.h |    2 ++
 src/chain.c                 |   24 ++++++++++++++++++------
 src/expr/counter.c          |    4 ++--
 src/rule.c                  |   19 ++++++++++++++++---
 src/table.c                 |   18 ++++++++++++++++--
 7 files changed, 58 insertions(+), 13 deletions(-)

-- 
Arturo Borrero Gonzalez
