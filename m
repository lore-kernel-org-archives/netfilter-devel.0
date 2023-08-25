Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB16EE49A6
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbjHYLcs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244494AbjHYLcg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59194268B
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YtlOHN6csD7xGO76OQ1puwBfbEQ0TF/7yotY48UJs54=;
        b=McTqYXhBSNvT8iqHzvHXLjvouR/ApHzl3oKjbD65EZMXKGi+ToHXC7fDze5JF030pNkHNA
        PevUoUyhumIn6C+20VEZK4v2Gpo4gf18mLMAhV9uxbdlSmBINHuuipK5KySLeMTi92TWrv
        Cauon2UXkDJzgygvzlBa292NAcu6oKk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-qTL7ILEeOCykDwtwoDOPhg-1; Fri, 25 Aug 2023 07:30:53 -0400
X-MC-Unique: qTL7ILEeOCykDwtwoDOPhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AB242808B31
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:30:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCBD740D2839;
        Fri, 25 Aug 2023 11:30:52 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 0/6] no recursive make
Date:   Fri, 25 Aug 2023 13:27:32 +0200
Message-ID: <20230825113042.2607496-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Switch from recursive make to a single toplevel Makefile.

[Quote commit message from first commit]

Unlike meson's subdir() or C's #include, automake's SUBDIRS= does not
include a Makefile. Instead, it calls `make -C $dir`.

  https://www.gnu.org/software/make/manual/html_node/Recursion.html
  https://www.gnu.org/software/automake/manual/html_node/Subdirectories.html

This has several problems, which we an avoid with a single Makefile:

- recursive make is harder to maintain and understand as a whole.
  Recursive make makes sense, when there are truly independent
  sub-projects. Which is not the case here. The project needs to be
  considered as a whole and not one directory at a time. When
  we add unit tests (which we should), those would reside in separate
  directories but have dependencies between directories. With a single
  Makefile, we see all at once. There is a certain complexity to the build
  setup, that complexity is not automatically reduced by splitting it into
  more files. On the contrary it helps to have it all at once place,
  provided that it's still sensibly structured, named and organized.

- typing `make` prints irrelevant "Entering directory" messages. So much
  so, that at the end of the build, the terminal is filled with such
  messages and we have to scroll to see what happened.

- with recursive make, during build we see:

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

  This shows the full filename, assuming that the developer works from
  the top level directory. The full name is useful, for example to
  copy+paste into the terminal.

- single Makefile is also faster:

    $ make && perf stat -r 200 -B make -j

  I measure 35msec vs. 80msec.

- recursive make limits parallel make. You have to craft the SUBDIRS= in
  the correct order. The dependencies between directories are limited,
  as make only sees "LDADD = $(top_builddir)/src/libnftables.la" and
  not the deeper dependencies for the library.

- I presume, some people like recursive make because of `make -C $subdir`
  to only rebuild one directory. Rebuilding the entire tree is very
  fast, so this feature seems not relevant. Also, as dependency handling
  is limited, we might wrongly not rebuild a target. For example,

        make check
        touch src/meta.c
        make -C examples check

  does not rebuild "examples/nft-json-file".
  What we now can do with single Makefile (and better than before), is
  `make examples/nft-json-file`, which works as desired.

Thomas Haller (6):
  build: drop recursive make for "include/**/Makefile.am"
  build: drop recursive make for "py/Makefile.am"
  build: drop recursive make for "files/**/Makefile.am"
  build: drop recursive make for "src/Makefile.am"
  build: drop recursive make for "examples/Makefile.am"
  build: drop recursive make for "doc/Makefile.am"

 Make_global.am                             |  21 --
 Makefile.am                                | 408 ++++++++++++++++++++-
 configure.ac                               |  16 -
 doc/Makefile.am                            |  30 --
 examples/Makefile.am                       |   6 -
 files/Makefile.am                          |   3 -
 files/examples/Makefile.am                 |   5 -
 files/nftables/Makefile.am                 |  14 -
 files/osf/Makefile.am                      |   2 -
 include/Makefile.am                        |  42 ---
 include/linux/Makefile.am                  |  12 -
 include/linux/netfilter/Makefile.am        |  10 -
 include/linux/netfilter_arp/Makefile.am    |   1 -
 include/linux/netfilter_bridge/Makefile.am |   1 -
 include/linux/netfilter_ipv4/Makefile.am   |   1 -
 include/linux/netfilter_ipv6/Makefile.am   |   1 -
 include/nftables/Makefile.am               |   1 -
 py/Makefile.am                             |   1 -
 src/Makefile.am                            | 122 ------
 19 files changed, 399 insertions(+), 298 deletions(-)
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

