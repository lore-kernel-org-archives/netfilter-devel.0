From: Steven Barth <cyrus@openwrt.org>
Subject: [nft PATCH 0/5] support for mini-gmp / embedded friendliness
Date: Sun, 28 Dec 2014 18:17:40 +0100
Message-ID: <1419787065-26146-1-git-send-email-cyrus@openwrt.org>
Cc: Steven Barth <cyrus@openwrt.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:56559 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaL1RqU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Dec 2014 12:46:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

mini-gmp is a minimal subset of libgmp maintained by the same people
While libgmp compiles to >400KB, adding mini-gmp only results in a
~30KB size increase of nft without the need to link to gmplib.
This increase usability on embedded platforms optimizing for size
and having no other use for libgmp.

This patchset:
* Adds mini-gmp from gmplib 6.0 and adds a configure switch
  --without-libgmp to enable it
* Replaces the use of unsupported functions (gmp_printf, gmp_sscanf)
  with suitable replacements
* Fixes some minor issues related to the change


Steven Barth (5):
  parser: rename VERSION token to HDRVERSION
  datatype: use mpz_set_str instead of gmp_sscanf
  erec: use stdio vasprintf instead of gmp_vasprintf
  mini-gmp: add mini-gmp source and headers from gmplib 6.0
  build: add --without-libgmp switch to disable use of shared libgmp

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
 13 files changed, 4782 insertions(+), 18 deletions(-)
 create mode 100644 include/mini-gmp.h
 create mode 100644 src/mini-gmp.c

-- 
2.1.4

