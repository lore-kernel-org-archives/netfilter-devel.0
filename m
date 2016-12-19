From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnftnl 1.0.7 release
Date: Mon, 19 Dec 2016 23:57:33 +0100
Message-ID: <20161219225733.GA9104@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Transfer-Encoding: 8bit
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51520 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753183AbcLSW5j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 17:57:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BC4A576E1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 23:57:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E0A3A0FC2
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 23:57:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F637A0FC4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 23:57:34 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.0.7

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem. The
library libnftnl has been previously known as libnftables. This library
is currently used by the nft command line tool.

This release includes the following list of updates:

* New nftnl_rule_cmp() interface to compare rules.

* Support for new kernel expressions:
 - Number Generator (a.k.a. numgen).
 - Routing (a.k.a. rt).
 - Range.
 - Inverted set lookups.
 - Inverted dynamic set updates (ie. rule mismatch on full sets).
 - Packet quota.
 - Hash.
 - Forward Information Base lookups (a.k.a. fib).
 - Reference to stateful objects (requires kernel 4.10-rc).
 - Notrack.

* Allow to add userdata to sets.

* Support for stateful objects, including quota and counter (requires
  kernel 4.10-rc).

* Support for layer 4 pseudoheader fields checksum updates (requires
  kernel 4.10-rc).

  ... and fixes.

You can download this library from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Thanks!

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="changes-libnftnl-1.0.7.txt"
Content-Transfer-Encoding: 8bit

Anders K. Pedersen (1):
      src: introduce rt expression

Arturo Borrero (2):
      expr: lookup: give support for inverted matching
      src: remove libmxml support

Arturo Borrero Gonzalez (1):
      src: update Arturo Borrero Gonzalez email

Carlos Falgueras García (19):
      src: Fix leak in nftnl_*_unset()
      chain: Check correct attribute
      src: fix missing error checking in parser functions
      set: Add new attribute into 'set' to store user data
      tests: Check set user data
      src: Fix missing nul-termination in nftnl_*_set_str()
      src: Fix nftnl_*_get_data() to return the real attribute length
      src: Constify iterators
      rule: Implement internal iterator for expressions
      tests: Add missing tests to test-script.sh
      expr: Fix lookup builder
      tests: Fix tests for immediate and lookup expressions
      tests: masq: Fix wrong expression creation
      utils: Fix out of bound access in nftnl_family2str
      expr: cmp: Use cmp2str() instead of directly access to array
      src: Implement rule comparison
      rule: Fix comparison between rules if number of expressions differ
      expr: data_reg: Fix DATA_CHAIN comparison
      expr: immediate: Fix verdict comparison

Florian Westphal (1):
      expr: add fib expression

Josue Alvarez (1):
      examples: nft-rule-get: selective rule dumping

Laura Garcia Liebana (5):
      expr: add hash expression
      expr: add number generation expression
      expr: numgen: Rename until attribute by modulus
      expr: hash: Add offset to hash value
      expr: numgen: add number generation offset

Liping Zhang (7):
      trace: use get_u32 to parse NFPROTO and POLICY attribute
      expr: queue: remove redundant NFTNL_EXPR_QUEUE_NUM set in json parse
      tests: queue: add missing NFTNL_EXPR_QUEUE_FLAGS compare test
      expr: queue: add NFTA_QUEUE_SREG_QNUM attr support
      expr: log: fix typo in nftnl_expr_log_export
      expr: log: do not print prefix if it is not set
      expr: log: complete log flags support

Pablo Neira Ayuso (43):
      examples: nft-table-upd: don't use deprecated aliases
      expr: payload: don't use deprecated definition NFT_EXPR_PAYLOAD_SREG
      src: assert when setting unknown attributes
      src: return value on setters that internally allocate memory
      src: check for strdup() errors from setters and parsers
      expr: data_reg: get rid of leftover perror() calls
      src: simplify unsetters
      src: check for flags before releasing attributes
      tests: shuffle values that are injected
      chain: dynamically allocate name
      tests: stricter string attribute validation
      set_elem: fix return in several error paths of nftnl_set_elems_parse2()
      expr: lookup: print flags only if they are available
      src: don't set data_len to zero when returning pointers
      Revert "common: Avoid integer overflow in nftnl_batch_is_supported()"
      expr: add quota expression
      expr: numgen: use switch to handle numgen types from snprintf
      expr: numgen: add missing trailing whitespace
      expr: hash: missing trailing space and modulus in hexadecimal in snprintf
      expr: numgen: add missing nftnl_expr_ng_cmp()
      set: fix incorrect maximum set description attribute
      include: resync nf_tables.h cache copy
      src: display offset only if present in hash and numgen expressions
      src: add range expression
      set_elem: don't add NFTA_SET_ELEM_LIST_ELEMENTS attribute if set is empty
      src: add notrack expression
      expr: missing offset handling for snprintf() in hash and numgen
      include: refresh nf_tables.h cache copy
      expr: call expr->ops->snprintf only if defined
      examples: add nft-map-add
      examples: nft-set-add: update it to add a set that stores port numbers
      examples: nft-set-elem-add: add missing batch logic
      expr: payload: add NFTNL_EXPR_PAYLOAD_FLAGS
      set_elem: nftnl_set_elems_nlmsg_build_payload_iter()
      include: fetch stateful object updates for nf_tables.h cache copy
      src: support for stateful objects
      expr: add stateful object reference expression
      set: add NFTNL_SET_OBJ_TYPE attribute
      set_elem: add NFTNL_SET_ELEM_OBJREF attribute
      expr: objref: add support for stateful object maps
      quota: support for consumed bytes
      build: update LIBVERSION to prepare a new release
      include: Missing nf_log.h in Makefile

Phil Sutter (7):
      set: prevent memleak in nftnl_jansson_parse_set_info()
      expr/ct: prevent array index overrun in ctkey2str()
      expr/limit: Drop unreachable code in limit_to_type()
      common: Avoid integer overflow in nftnl_batch_is_supported()
      src: Avoid returning uninitialized data
      ruleset: Initialize ctx.flags before calling nftnl_ruleset_ctx_set()
      utils: Don't return directly from SNPRINTF_BUFFER_SIZE


--2oS5YaxWCcQjTEyO--
