Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9706C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 10:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKBKWS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 06:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKBKWR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 06:22:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E39A724BF9;
        Wed,  2 Nov 2022 03:22:11 -0700 (PDT)
Date:   Wed, 2 Nov 2022 11:22:08 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] ulogd 2.0.8 release
Message-ID: <Y2JE0PygwmrhC6Q1@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="R4jNzl7zVqqRGgl4"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--R4jNzl7zVqqRGgl4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        ulogd 2.0.8

ulogd is a userspace logging daemon for netfilter/iptables related
logging. This includes per-packet logging and per-flow logging as
well as flexible user-defined accounting. This also includes output
plugins to represent logging using different backends such as mysql,
postgresql, pcap, json among others.

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/ulogd/downloads.html

Happy firewalling.

--R4jNzl7zVqqRGgl4
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-ulogd-2.0.8.txt"

Ander Juaristi (2):
      IPFIX: Add IPFIX output plugin
      IPFIX: Introduce template record support

Andreas Jaggi (2):
      ulogd: json: send messages to a remote host / unix socket
      ulogd: printpkt: always print IPv6 protocol

Cameron Norman (1):
      ulogd: fix build with musl libc

Cole Dishington (1):
      printpkt: print pkt mark like kernel

Jeremy Sowden (62):
      gitignore: add Emacs artefacts
      gitignore: ignore .dirstamp
      build: remove unused Makefile fragment
      build: remove empty filter sub-directory
      build: move CPP `-D` flag.
      build: add Make_global.am for common flags
      build: use `dist_man_MANS` to declare man-pages
      build: skip sub-directories containing disabled plugins
      build: group `*_la_*` variables with their libraries
      build: delete commented-out code
      build: use correct automake variable for library dependencies
      build: update obsolete autoconf macros
      build: remove commented-out code
      build: quote autoconf macro arguments
      build: use `AS_IF` consistently in configure.ac
      include: add `format` attribute to `__ulogd_log` declaration
      ulogd: remove empty log-line
      ulogd: fix order of log arguments
      input: UNIXSOCK: correct format specifiers
      output: IPFIX: correct format specifiers
      jhash: add "fall through" comments to switch cases
      db: add missing `break` to switch case
      filter: HWHDR: simplify flow-control
      filter: HWHDR: re-order KEY_RAW_MAC checks
      filter: HWHDR: remove zero-initialization of MAC type
      Replace malloc+memset with calloc
      filter: PWSNIFF: replace malloc+strncpy with strndup
      input: UNIXSOCK: remove stat of socket-path
      input: UNIXSOCK: fix possible truncation of socket path
      input: UNIXSOCK: prevent unaligned pointer access
      output: DBI: fix deprecation warnings
      output: DBI: improve mapping of DB columns to input-keys
      output: DBI: fix NUL-termination of escaped SQL string
      output: DBI: fix configuration of DB connection
      output: MYSQL: improve mapping of DB columns to input-keys
      output: PGSQL: improve mapping of DB columns to input-keys
      output: PGSQL: fix non-`connstring` configuration of DB connection
      output: SQLITE3: fix possible buffer overruns
      output: SQLITE3: fix memory-leak in error-handling
      build: bump libnetfilter_log dependency
      output: SQLITE3: improve formatting of insert statement
      output: SQLITE3: improve mapping of DB columns to fields
      output: SQLITE3: catch errors creating SQL statement
      db: improve formatting of insert statement
      db: improve mapping of input-keys to DB columns
      db: simplify initialization of ring-buffer
      output: JSON: fix output of GMT offset
      output: JSON: increase time-stamp buffer size
      output: JSON: fix possible leak in error-handling.
      output: JSON: optimize appending of newline to output
      output: IPFIX: remove compiler attribute macros
      output: SQLITE3: remove unused variable
      build: use `--enable-XYZ` options for output plugins
      build: use pkg-config for libdbi
      build: use pkg-config or mysql_config for libmysqlclient
      build: use pkg-config or pcap-config for libpcap
      build: use pkg-config or pg_config for libpq
      build: if `--enable-dbi` is `yes`, abort if libdbi is not found
      build: if `--enable-mysql` is `yes`, abort if libmysqlclient is not found
      build: if `--enable-pcap` is `yes`, abort if libpcap is not found
      build: if `--enable-pgsql` is `yes`, abort if libpq is not found
      build: if `--enable-sqlite3` is `yes`, abort if libsqlite3 is not found

Ken-ichirou MATSUZAWA (5):
      XML: support nflog pkt output
      NFLOG: fix seq global flag setting
      NFLOG: add NFULNL_CFG_F_CONNTRACK flag
      NFLOG: attach struct nf_conntrack
      XML: show both nflog packet and conntrack

Pablo Neira Ayuso (6):
      build: missing ipfix.h header when running make distcheck
      output: SQLITE3: improve mapping of fields to DB columns
      output: JSON: fix possible truncation of socket path
      output: JSON: remove bogus check for host and port
      output: GPRINT: fix it with NFLOG
      build: bump release version to 2.0.8

Timon Ulrich (1):
      raw2packet: fix comma instead of semicolon


--R4jNzl7zVqqRGgl4--
