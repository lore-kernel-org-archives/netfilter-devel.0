Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C08C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jan 2022 21:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbiAJV0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 16:26:08 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44662 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344436AbiAJV0B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 16:26:01 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8BE2163F5A;
        Mon, 10 Jan 2022 22:23:09 +0100 (CET)
Date:   Mon, 10 Jan 2022 22:25:56 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 00/10] Add pkg-config support
Message-ID: <YdykZPrWzek+3P71@salvia>
References: <20220109115753.1787915-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220109115753.1787915-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 09, 2022 at 11:57:43AM +0000, Jeremy Sowden wrote:
> A number of third-party libraries have added pkg-config support over the
> years.  This patch-set updates configure to make use of it where it is
> available.  It also fixes some conflicting option definitions and adds
> checks that cause configure to fail if a plugin has been explicitly
> requested, but the related third-party library is not available.
> 
> Patch 1:      switch from `--with-XXX` to `--enable-XXX` for output
>               plugins.
> Patches 2-5:  use pkg-config for libdbi, libmysqlclient, libpcap and
>               libpq if available.
> Patches 6-10: abort configure when an output plugin has been explicitly
>               enabled, but the related library is not available.
> 
> Changes since v1
> 
>   * Better commit messages.
>   * Simpler mysql patch: remove the upstream m4 macro calls, and look
>     for `mysql_config` the same way we do `pg_config` and `pcap-config`.
>   * `AM_CPPFLAGS` fixes for mysql, pcap, and postgresql.
>   * `LIBADD` fix for mysql.
> 
> Jeremy Sowden (10):
>   build: use `--enable-XXX` options for output plugins

I hesitate about this change from --with-XYZ to --enable-XYZ, it will
force package maintainers to update their scripts.

Althought I agree after reading the documentation that --enable-XYZ
might make more sense since the input plugins rely on netfilter
libraries which are supposed to be "external software".

>   build: use pkg-config for libdbi
>   build: use pkg-config or mysql_config for libmysqlclient
>   build: use pkg-config or pcap-config for libpcap
>   build: use pkg-config or pg_config for libpq
>   build: if `--enable-dbi` is `yes`, abort if libdbi is not found
>   build: if `--enable-mysql` is `yes`, abort if libmysqlclient is not
>     found
>   build: if `--enable-pcap` is `yes`, abort if libpcap is not found
>   build: if `--enable-pgsql` is `yes`, abort if libpq is not found
>   build: if `--enable-sqlite3` is `yes`, abort if libsqlite3 is not
>     found
> 
>  acinclude.m4             | 351 ---------------------------------------
>  configure.ac             | 192 +++++++++++++++++----
>  output/dbi/Makefile.am   |   4 +-
>  output/mysql/Makefile.am |   4 +-
>  output/pcap/Makefile.am  |   2 +
>  output/pgsql/Makefile.am |   4 +-
>  6 files changed, 165 insertions(+), 392 deletions(-)
>  delete mode 100644 acinclude.m4
> 
> -- 
> 2.34.1
> 
