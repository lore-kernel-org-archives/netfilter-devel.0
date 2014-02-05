From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC libnftnl PATCH 0/2] New mnlio functions
Date: Wed, 05 Feb 2014 20:17:41 +0100
Message-ID: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35401 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751559AbaBETRv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:17:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These functions are likely to be reused by almost all programs
that want to talk with the kernel subsystem.

We can add here to libnftnl or maybe put in a higher level library.

Let this patchset be a RFC about this subject.

An example of what means using the new mnlio approach is the
examples/nft-rule-add.c file. We save lots of LOCs.

Comments welcome.

NOTE: this patchset would require several iterations. For example,
I left behind batch_pages.
---

Arturo Borrero Gonzalez (2):
      src: add mnlio API functions
      examples: use new mnlio API in nft-rule-add.c


 examples/nft-rule-add.c      |   87 ----
 include/libnftnl/Makefile.am |    3 
 include/libnftnl/mnlio.h     |   92 ++++
 src/Makefile.am              |    1 
 src/libnftnl.map             |   37 ++
 src/mnlio.c                  |  957 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1096 insertions(+), 81 deletions(-)
 create mode 100644 include/libnftnl/mnlio.h
 create mode 100644 src/mnlio.c

-- 
Arturo Borrero Gonzalez
