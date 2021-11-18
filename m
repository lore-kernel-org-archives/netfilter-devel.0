Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF7AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 10:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37937613D0
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 10:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245435AbhKRKrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 05:47:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42318 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbhKRKrZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 05:47:25 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 47497607A0;
        Thu, 18 Nov 2021 11:42:17 +0100 (CET)
Date:   Thu, 18 Nov 2021 11:44:20 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnetfilter_log 1.0.2 release
Message-ID: <YZYuhP3VbuYXs+Xl@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CBicxE2aBrVBHsm2"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--CBicxE2aBrVBHsm2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_log 1.0.2

libnetfilter_log is a userspace library providing interface to packets
that have been logged by the kernel packet filter. It is is part of a
system that deprecates the old syslog/dmesg based packet logging. This
library has been previously known as libnfnetlink_log. This library
is used by ulogd2.

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/libnetfilter_log/downloads.html
https://www.netfilter.org/pub/libnetfilter_log/

Happy firewalling.

--CBicxE2aBrVBHsm2
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="changes-libnetfilter_log-1.0.2.txt"

Duncan Roe (13):
      src: whitespace: Remove trailing whitespace and inconsistent indents
      build: doc: reduce doxygen.cfg.in to non-default entries only
      build: doc: remove trailing whitespace from doxygen.cfg.in
      src: doc: Eliminate doxygen warnings
      src: consistently use `gh` in code, code snippets and examples
      src: doc: revise doxygen for module "Netlink message helper functions"
      utils: nfulnl_test: Print meaningful error messages
      src: doc: revise doxygen for all other modules
      src: doc: Insert SYNOPSIS sections for man pages
      src: doc: Add \return for nflog_get_packet_hw()
      src: doc: Document nflog_callback_register() and nflog_handle_packet()
      utils: nfulnl_test: Agree with man pages
      build: doc: `make` generates requested documentation

Eric Leblond (1):
      Add include needed for integer type definition.

Felix Janda (3):
      configure: Make it possible to build libipulog
      include: Sync with current kernel headers
      src: Use stdint types everywhere

Gustavo Zacarias (1):
      configure: uclinux is also linux

Jan Engelhardt (4):
      build: remove unnecessary pkgconfig->config.status dependency
      build: remove unused lines in Makefile.am
      build: resolve automake-1.12 warnings
      build: choose right automake variables

Jeremy Sowden (21):
      include: Add extern "C" declarations to header-files.
      build: remove duplicate `-lnfnetlink` from LDFLAGS.
      build: link libnetfilter_log_libipulog.so explicitly to libnfnetlink.so.
      build: remove broken code from autogen.sh.
      Add doxygen directory to .gitignore.
      build: remove references to non-existent man-pages.
      doc: fix typo's in example.
      src: use calloc instead of malloc + memset.
      libipulog: use correct index to find attribute in packet.
      libipulog: fill in missing packet fields.
      build: add LIBVERSION variable for ipulog
      build: correct pkg-config dependency configuration
      build: add pkg-config configuration for libipulog
      build: fix linker flags for nf-log
      build: move dependency CFLAGS variables out of `AM_CPPFLAGS`
      build: remove superfluous .la when linking ulog_test
      build: remove `-dynamic` when linking check progs
      build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with `LT_INIT`
      build: replace `AC_HELP_STRING` with `AS_HELP_STRING`
      Add Emacs artefacts to .gitignore
      build: fix pkg-config syntax-errors

Ken-ichirou MATSUZAWA (8):
      build: fix typo
      src: introduce new functions independent from libnfnetlink
      utils: take a example from libmnl and use new functions
      nlmsg: add printf function in conjunction with libmnl
      include: Sync with kernel headers
      nlmsg: Add NFULA_CT and NFULA_CT_INFO attributes support
      utils: nf-log: attaching a conntrack information
      src: add conntrack ID to XML output

Matthieu Crapet (1):
      configure: add --without-ipulog option to disable libipulog build

Natanael Copa (1):
      include: Add include needed for integer type definition.

Pablo Neira Ayuso (4):
      build: missing internal.h in Makefile.am
      utils: nfulnl_test: call nflog_get_*() before printing field
      utils: nfulnl_test: use nflog_get_packet_hw() and print hardware address
      build: bump version to 1.0.2


--CBicxE2aBrVBHsm2--
