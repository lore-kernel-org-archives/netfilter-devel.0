From: Steven Barth <cyrus@openwrt.org>
Subject: [nft PATCHv2 0/4] support for mini-gmp / embedded friendliness
Date: Tue,  6 Jan 2015 23:40:21 +0100
Message-ID: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Cc: Steven Barth <cyrus@openwrt.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:58357 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbAFWlB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:41:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mini-gmp is a minimal subset of libgmp maintained by the same people
While libgmp compiles to >400KB, adding mini-gmp only results in a
~30KB size increase of nft without the need to link to gmplib.
This increase usability on embedded platforms optimizing for size
and having no other use for libgmp.

This patchset:
* Adds mini-gmp from gmplib 6.0 and adds a configure switch
  --with-mini-gmp to enable it
* Replaces the use of unsupported functions (gmp_printf, gmp_sscanf)
  with suitable replacements
* Fixes some minor issues related to the change

Steven Barth (4):
  parser: rename VERSION token to HDRVERSION
  datatype: use mpz_set_str instead of gmp_sscanf
  erec: use stdio vasprintf instead of gmp_vasprintf
  build: add --with-mini-gmp switch to use mini-gmp instead of libgmp

 INSTALL              |    6 +
 configure.ac         |   17 +-
 include/expression.h |    2 +-
 include/gmputil.h    |   10 +
 include/mini-gmp.h   |  294 ++++
 include/utils.h      |    4 +-
 src/Makefile.am      |    4 +
 src/datatype.c       |    4 +-
 src/erec.c           |    6 +-
 src/evaluate.c       |    8 +-
 src/gmputil.c        |   57 +-
 src/mini-gmp.c       | 4386 ++++++++++++++++++++++++++++++++++++++++++++++++++
 src/parser_bison.y   |    6 +-
 src/scanner.l        |    2 +-
 14 files changed, 4788 insertions(+), 18 deletions(-)
 create mode 100644 include/mini-gmp.h
 create mode 100644 src/mini-gmp.c

-- 
2.1.4

