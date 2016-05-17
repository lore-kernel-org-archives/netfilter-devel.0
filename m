From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnetfilter_conntrack PATCH 0/3] support for IPv6 NAT
Date: Tue, 17 May 2016 14:50:26 +0200
Message-ID: <146348935823.4910.10745657047372991575.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55655 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751303AbcEQMuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 08:50:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements support for IPv6 NAT, which
was lacking in this library and in conntrackd.

I will to follow-up with the conntrackd patches, but I would like
to get an early review on these 3 patches to know if I'm working in the
right direction.

Comments welcome.

---

Arturo Borrero Gonzalez (3):
      src: add support for IPv6 to struct __nfct_nat
      src: add support for IPv6 NAT
      qa: update test_api with IPv6 NAT


 include/internal/object.h                          |    2 
 .../libnetfilter_conntrack.h                       |    2 
 qa/test_api.c                                      |    2 
 src/conntrack/build.c                              |   69 +++++++++++++---
 src/conntrack/build_mnl.c                          |   65 +++++++++++++--
 src/conntrack/copy.c                               |   20 ++++-
 src/conntrack/getter.c                             |   16 +++-
 src/conntrack/objopt.c                             |   85 ++++++++++++++++----
 src/conntrack/setter.c                             |   20 ++++-
 9 files changed, 236 insertions(+), 45 deletions(-)

--
