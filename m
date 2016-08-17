From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 00/10 nft] syntax updates
Date: Wed, 17 Aug 2016 15:29:51 +0200
Message-ID: <1471440601-5327-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44000 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbcHQNaL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 09:30:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 74CC1E9762
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 638C9FF12D
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CDE98DA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 15:30:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following patchset is addressing part of the syntax issues that we
have discussed during the NFWS.

1) Quote user-defined strings from rule selectors. The current behaviour
   is inconsistent since some selectors are quoting user-defined strings
   and others do not, so let's quote them all.

2) Add 'to' for snat and dnat to keep it consistent with redirect,
   masquerade, dup and fwd.

3) Support for Ipv6 address between brackets.

4) Missing QUOTED_STRING and ASTERISK_STRING token descriptions.

5) Allow strings that start by _ and . so we comply with POSIX.1-2008.

6) Kill useless range patter from scanner.

7,8,9) Add meta priority support using minor:major syntax.

10) Add colon after 'redirect to' for consistency with nat and
   masquerade.

Comments welcome.

Pablo Neira Ayuso (10):
  src: quote user-defined strings when used from rule selectors
  src: add 'to' for snat and dnat
  src: support for RFC2732 IPv6 address format with brackets
  parser_bison: missing token string in QUOTED_ASTERISK and ASTERISK_STRING
  scanner: allow strings starting by underscores and dots
  scanner: remove range expression
  src: rename datatype name from tc_handle to classid
  src: simplify classid printing using %x instead of %04x
  src: meta priority support using tc classid
  parser_bison: redirect to :port for consistency with nat/masq statement

 include/datatype.h                  |  6 +--
 src/cli.c                           |  8 +++
 src/ct.c                            |  2 +-
 src/datatype.c                      | 12 +++--
 src/erec.c                          |  1 +
 src/main.c                          |  3 +-
 src/meta.c                          | 66 ++++++++++++++-----------
 src/parser_bison.y                  | 27 ++++++----
 src/proto.c                         |  2 +-
 src/scanner.l                       | 16 +++++-
 src/statement.c                     | 26 ++++++++--
 tests/py/any/meta.t                 | 80 ++++++++++++++++--------------
 tests/py/any/meta.t.payload         | 99 ++++++++++++++++++++++++++++++++-----
 tests/py/ip/dnat.t                  | 16 +++---
 tests/py/ip/dnat.t.payload.ip       | 12 ++---
 tests/py/ip/redirect.t              | 24 ++++-----
 tests/py/ip/redirect.t.payload      | 20 ++++----
 tests/py/ip/snat.t                  | 12 ++---
 tests/py/ip/snat.t.payload          |  8 +--
 tests/py/ip6/dnat.t                 |  5 +-
 tests/py/ip6/dnat.t.payload.ip6     | 14 +++++-
 tests/py/ip6/redirect.t             | 18 +++----
 tests/py/ip6/redirect.t.payload.ip6 | 14 +++---
 tests/py/ip6/snat.t                 |  4 +-
 tests/py/ip6/snat.t.payload.ip6     |  4 +-
 25 files changed, 325 insertions(+), 174 deletions(-)

-- 
2.1.4

