From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnftnl 1.0.6 release
Date: Mon, 30 May 2016 12:55:45 +0200
Message-ID: <20160530105545.GA16431@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Transfer-Encoding: 8bit
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32955 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbcE3Kz6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 06:55:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ECF281B5CA7
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 12:55:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D8F9315D64D
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 12:55:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1427315D642
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 12:55:52 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.0.6

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This
library is currently used by the nft command line tool.

This release includes the following list of updates:

* New TLV infrastructure for user data are in rule, set and elements.
* Support for the new tracing infrastructure.
* Matching of ct bytes and packets.
* meta prandom support.
* Enhancements for the limit expressions.
* Support for payload mangling.
* Masquerading port range selection.
  ... and fixes.

You can download this library from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Enjoy this new release and help us testing, thanks!


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-libnftnl-1.0.6.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero (2):
      chain: fix segfault in 'device' XML parsing
      expr: ct: fix typo unknow vs unknown

Carlos Falgueras García (8):
      udata: add TLV user data infrastructure
      tests: nft-rule-test: check for NFTNL_RULE_USERDATA
      libnftnl: Add to .gitignore all auto-generated files
      libnftnl: gitignore: Fix mistake in gitignore regexp
      tests: Free nftnl_udata_buf before exit
      rule: Fix segfault due to invalid free of rule user data
      set_elem: Fix memory leak
      set_elem: Copy user data memory

Daniel Wagner (1):
      examples: load modules when adding chains or tables

Florian Westphal (4):
      src: rename EXPORT_SYMBOL to EXPORT_SYMBOL_ALIAS
      src: add trace infrastructure support
      src: ct: add packet and byte counter support
      src: meta: add prandom support

Pablo Neira Ayuso (13):
      expr: limit: add burst attribute
      expr: limit: add per-byte limiting support
      expr: add dup expression support
      expr: dup: fix missing space in text output
      expr: limit: add support for flags
      expr: add forward expression
      rule: fix leaks in NFTNL_RULE_USERDATA
      libnftnl: allow any set name length
      src: remove unnecessary inline in _snprintf functions
      src: missing static in several array definitions
      chain: missing constification of _get() functions
      include: refresh nf_tables.h cache copy
      build: update LIBVERSION to prepare a new release

Patrick McHardy (4):
      payload: add payload mangling support
      trace: fix multiple copy and paste errors
      trace: fix missing NFTNL_TRACE_JUMP_TARGET in nftnl_trace_get_str()
      libnftnl: constify object arguments to various functions

Shivani Bhardwaj (2):
      expr: masq: Add support for port selection
      tests: expr-nat: Use different values to test

Vijay Subramanian (3):
      expr: Fix compilation with JSON and XML parsing enabled
      examples: Fix nft-table-upd example
      Add support to print netdev family


--2oS5YaxWCcQjTEyO--
