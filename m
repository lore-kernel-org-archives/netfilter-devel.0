From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 0/5] XML works
Date: Wed, 10 Apr 2013 18:39:52 +0200
Message-ID: <20130410163912.6303.8705.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36324 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932468Ab3DJQj4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:39:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements:

 * small XML format fixes in printing.
 * a workaround for target/match binary data.
 * delete all \n and \t in XML printing.
 * print expr flags in XML (the <expr_flags> node)
 * [RFC] XML-to-object parsing.

Note that for XML parsing i've used libmxml (http://minixml.org/)

Also, please consider the XML parsing code a RFC.

---

Arturo Borrero (5):
      src: rule: small fix XML output
      src: expr: XML printing for binary data in targer and match
      src: xml printing: delete text format
      src: expr: print flags in XML
      src: support for XML parsing


 Make_global.am              |    2 
 configure.ac                |    1 
 include/libnftables/chain.h |    1 
 include/libnftables/rule.h  |    1 
 include/libnftables/table.h |    1 
 src/chain.c                 |  206 ++++++++++++++++++++++++++++++++++--
 src/expr/bitwise.c          |  151 ++++++++++++++++++++++++--
 src/expr/cmp.c              |  139 +++++++++++++++++++++++-
 src/expr/counter.c          |   87 +++++++++++++++
 src/expr/data_reg.c         |  249 +++++++++++++++++++++++++++++++++++++++++++
 src/expr/immediate.c        |  118 ++++++++++++++++++++
 src/expr/lookup.c           |  107 +++++++++++++++++-
 src/expr/match.c            |  146 ++++++++++++++++++++++++-
 src/expr/meta.c             |   84 ++++++++++++++-
 src/expr/nat.c              |  159 +++++++++++++++++++++++++++
 src/expr/payload.c          |  118 ++++++++++++++++++++
 src/expr/target.c           |  148 +++++++++++++++++++++++++-
 src/expr_ops.h              |    1 
 src/libnftables.map         |    3 +
 src/rule.c                  |  189 ++++++++++++++++++++++++++++++++-
 src/table.c                 |  102 ++++++++++++++++--
 21 files changed, 1937 insertions(+), 76 deletions(-)

-- 
Signature
