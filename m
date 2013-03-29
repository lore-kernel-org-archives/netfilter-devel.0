From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 0/2]
Date: Fri, 29 Mar 2013 16:34:21 +0100
Message-ID: <20130329153155.30122.21803.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44439 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755393Ab3C2Peb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:34:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series implements:
        * A typo fix.
        * src: expr: nft_data_reg support for XML output.

Please, note that the XML output of nft_data_reg stills need some work, such as
endianess related issues and how to print the other part of the union.
This is intended to be the first basic approach.

Also, comments are welcome.

---

Arturo Borrero (2):
      Fix a typo in src/expr/match
      Basic support for printing nft_data_reg in XML format.


 src/expr/bitwise.c   |   33 ++++++++++++++-------------------
 src/expr/cmp.c       |   23 +++++++++++------------
 src/expr/data_reg.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 src/expr/data_reg.h  |    3 +++
 src/expr/immediate.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 src/expr/match.c     |    4 ++--
 6 files changed, 116 insertions(+), 38 deletions(-)

-- 
Arturo Borrero Gonzalez
