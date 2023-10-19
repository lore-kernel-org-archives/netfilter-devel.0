Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B23ACDB483
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235455AbjJSNC5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345641AbjJSNCt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:02:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299C45248
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697720474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PI7QTd6p3g8Gp+YGyB4p2A3kDZU0SGUEeDlxTmVs0g4=;
        b=UauCsgZAYuXAJMPr3Mi0YRe4uavAkYfRmua8+g1aQ/SoUzH/Bc7cyiQHAHwceTTRvbVqmc
        R9Ei781HUbhEOLy0ntzBgMuV/Kl3e0EHEAVacZBaBdO5QY76HAupva1avxYjXqL+Nginoh
        ry9qdzOhZKXC6PyT/RfM5m/XT5DLr8o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-wwOx_Za6Msaecd3tfzqh1w-1; Thu, 19 Oct 2023 09:01:09 -0400
X-MC-Unique: wwOx_Za6Msaecd3tfzqh1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 461481C068D8
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 13:01:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC1A6503B;
        Thu, 19 Oct 2023 13:01:07 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 0/7] no recursive make
Date:   Thu, 19 Oct 2023 14:59:59 +0200
Message-ID: <20231019130057.2719096-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a RESEND of v1. Only minor adjustments to the commit message and
rebasing.

[Quote commit message from first patch]

Switch from recursive-make to a single top-level Makefile. This is the
first step, the following patches will continue this.

Unlike meson's subdir() or C's #include, automake's SUBDIRS= does not
include a Makefile. Instead, it calls `make -C $dir`.

  https://www.gnu.org/software/make/manual/html_node/Recursion.html
  https://www.gnu.org/software/automake/manual/html_node/Subdirectories.html

See also, "Recursive Make Considered Harmful".

  https://accu.org/journals/overload/14/71/miller_2004/

This has several problems, which we an avoid with a single Makefile:

- recursive-make is harder to maintain and understand as a whole.
  Recursive-make makes sense, when there are truly independent
  sub-projects. Which is not the case here. The project needs to be
  considered as a whole and not one directory at a time. When
  we add unit tests (which we should), those would reside in separate
  directories but have dependencies between directories. With a single
  Makefile, we see all at once. The build setup has an inherent complexity,
  and that complexity is not necessarily reduced by splitting it into more files.
  On the contrary it helps to have it all in once place, provided that it's
  sensibly structured, named and organized.

- typing `make` prints irrelevant "Entering directory" messages. So much
  so, that at the end of the build, the terminal is filled with such
  messages and we have to scroll to see what even happened.

- with recursive-make, during build we see:

    make[3]: Entering directory '.../nftables/src'
      CC       meta.lo
    meta.c:13:2: error: #warning hello test [-Werror=cpp]
       13 | #warning hello test
          |  ^~~~~~~

  With a single Makefile we get

      CC       src/meta.lo
    src/meta.c:13:2: error: #warning hello test [-Werror=cpp]
       13 | #warning hello test
          |  ^~~~~~~

  This shows the full filename -- assuming that the developer works from
  the top level directory. The full name is useful, for example to
  copy+paste into the terminal.

- single Makefile is also faster:

    $ make && perf stat -r 200 -B make -j

  I measure 35msec vs. 80msec.

- recursive-make limits parallel make. You have to craft the SUBDIRS= in
  the correct order. The dependencies between directories are limited,
  as make only sees "LDADD = $(top_builddir)/src/libnftables.la" and
  not the deeper dependencies for the library.

- I presume, some people like recursive-make because of `make -C $subdir`
  to only rebuild one directory. Rebuilding the entire tree is already very
  fast, so this feature seems not relevant. Also, as dependency handling
  is limited, we might wrongly not rebuild a target. For example,

        make check
        touch src/meta.c
        make -C examples check

  does not rebuild "examples/nft-json-file".
  What we now can do with single Makefile (and better than before), is
  `make examples/nft-json-file`, which works as desired and rebuilds all
  dependencies.

<<<<

Thomas Haller (7):
  gitignore: ignore ".dirstamp" files
  build: no recursive-make for "include/**/Makefile.am"
  build: no recursive make for "py/Makefile.am"
  build: no recursive make for "files/**/Makefile.am"
  build: no recursive make for "src/Makefile.am"
  build: no recursive make for "examples/Makefile.am"
  build: no recursive make for "doc/Makefile.am"

 .gitignore                                 |   1 +
 Make_global.am                             |  21 --
 Makefile.am                                | 415 ++++++++++++++++++++-
 configure.ac                               |  16 -
 doc/Makefile.am                            |  30 --
 examples/Makefile.am                       |   6 -
 files/Makefile.am                          |   3 -
 files/examples/Makefile.am                 |   5 -
 files/nftables/Makefile.am                 |  14 -
 files/osf/Makefile.am                      |   2 -
 include/Makefile.am                        |  43 ---
 include/linux/Makefile.am                  |  12 -
 include/linux/netfilter/Makefile.am        |  10 -
 include/linux/netfilter_arp/Makefile.am    |   1 -
 include/linux/netfilter_bridge/Makefile.am |   1 -
 include/linux/netfilter_ipv4/Makefile.am   |   1 -
 include/linux/netfilter_ipv6/Makefile.am   |   1 -
 include/nftables/Makefile.am               |   1 -
 py/Makefile.am                             |   1 -
 src/Makefile.am                            | 123 ------
 20 files changed, 407 insertions(+), 300 deletions(-)
 delete mode 100644 Make_global.am
 delete mode 100644 doc/Makefile.am
 delete mode 100644 examples/Makefile.am
 delete mode 100644 files/Makefile.am
 delete mode 100644 files/examples/Makefile.am
 delete mode 100644 files/nftables/Makefile.am
 delete mode 100644 files/osf/Makefile.am
 delete mode 100644 include/Makefile.am
 delete mode 100644 include/linux/Makefile.am
 delete mode 100644 include/linux/netfilter/Makefile.am
 delete mode 100644 include/linux/netfilter_arp/Makefile.am
 delete mode 100644 include/linux/netfilter_bridge/Makefile.am
 delete mode 100644 include/linux/netfilter_ipv4/Makefile.am
 delete mode 100644 include/linux/netfilter_ipv6/Makefile.am
 delete mode 100644 include/nftables/Makefile.am
 delete mode 100644 py/Makefile.am
 delete mode 100644 src/Makefile.am

-- 
2.41.0

