Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D50715530F
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774568; cv=none; b=kK1l0XCOZqMQwsVZuCT3x+GJnAlpyZDaojl2/t7Iqvg1xc+mSJu13F1x9C7m11DBTlVCRL48wtAzovBjwao+tqoVue4BBlud/DcxC5MpliQUOhclnYzM1AHVO+24LN5pHQTR55E2noP1wJEDJW7jVa+nc0Cq6UNMaJL21PkMsN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774568; c=relaxed/simple;
	bh=oT3IG2KkE3egHlL301nk5JpktdZ4FrVZddUC7k/xrA4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qxH5O0CAIW4yPku62HNDkoet3Q2mFlEkNDKvMLKQufmUGzSfjNHrw+uaXoJsrSYxLWEaaKyJgwcBczimx7seAdN7jArmo4GOL6Zx36upgAyLffvziezXR3AZO5UGadan2RItVvNqhgSf61VgMx9uys8QUVGKVy8x0g4tnnDw8mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ig5hNquy; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ig5hNquy"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e5a1c9071so168862b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728774562; x=1729379362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbd3EjhtjM6YSnkHR+TWwGsnX/G4RQNv3NCHg22l5lQ=;
        b=Ig5hNquyWOQnyW+0VJF7zChKZTUb+Ev58mYGEnK/zv+F/Y8brxpBegaRDE4Co/6+dc
         VRVTh+t/rzSUVD+BRiCZa40tJBSbXt4PU3fYBK38/gQsOgr9DlfqIR0GGo95D9aedLGz
         VYssxEfFn/ZbyWWMhx21dHZNAZW01xxnjskLX0bHiK4380ADejGH5No0H8tRfazNdQPl
         y5JBrxK2NTCOrz/TY0VYjmwWvPs6WafpN7MJxrh8satOsmbhccjW7dwtjkVUryndMVzS
         7JlCpl7pSFch8r72NCS/QLdxPUObNRk+Qhs++C8yyXjAYN00VQQRi2N/wIZ6bg7v8KnE
         kYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728774562; x=1729379362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wbd3EjhtjM6YSnkHR+TWwGsnX/G4RQNv3NCHg22l5lQ=;
        b=wS4JXUiLUdqhtKG/OK7A23XtR38gPoc1H0mnOw3xf6/c2mGz69IFhaUS1GZSFd5xcd
         ZRSK222X+tDrnEJuLmqlazoQqIC3jUoWV++y3gZDO3iIVvMGcOMKb6tfBkrJ9IspE3p5
         PoYgAcP3sNe2j1vl/sngZj/gYkg3RPcVf7mTmkmDatyqjJMDAhV+11492NzPW2KyQIHo
         iB89Pwl3bRfAj3iiJu8Z/olNCjVjwTXAXu0BBvqTlQLoB1c8JQ3SBHiYMN6l7WXlv8M0
         0H0ti+AsIAJqGn/vQDYO/Iwu5rjaKDdft5bhlVDAKfxbSsMBs/H3T/5UsL2QGgVd00H4
         hnpw==
X-Gm-Message-State: AOJu0YzhS4a1p2UCtHcd5yHN0m+qIqFrnXkbCCsblHMmFIR6FwEymab7
	epRoq+9dHWX4MhXYCUdpt3HoyBpNzXUEGMKudYkFwSOvRYG9Cb1pfMV7tA==
X-Google-Smtp-Source: AGHT+IGBurb5gVB78BQ/I2OEran96j9xP2zigRRuqcMilV3tbiofqQp14HLSeL1So305Ubt6KSjBoQ==
X-Received: by 2002:a05:6a00:3d52:b0:71e:620:8e0a with SMTP id d2e1a72fcca58-71e37e28291mr11100514b3a.5.1728774562355;
        Sat, 12 Oct 2024 16:09:22 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e2aab5bf9sm4854195b3a.145.2024.10.12.16.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:09:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 00/15] Convert libnetfilter_queue to not need libnfnetlink
Date: Sun, 13 Oct 2024 10:09:02 +1100
Message-Id: <20241012230917.11467-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The general method is to make the opaque struct nfq_handle contain fully
populated libnfnetlink-style and libmnl-style handles.
Patch 1 (nfq_open()) and patch 2 (nfq_open_nfnl()) sets this up.
Patch 3 (nfq_close()) cleans it away.
Patches 3-10 convert the other nfq_* functions that used to use
  libnfnetlink, except for the nfq_get_*_name functions that need nlif.
Patches 11-13 provide all the nlif_* functions that libnfnetlink used to
  offer, converted to use libmnl.
Patch 14 removes all use of and reference to header files provided by
  libnfnetlink. It provides prototypes as required.
Patch 15 removes libnfnetlink as a private library.

There is a tester for this patchset at
https://github.com/duncan-roe/nfqnltester
Some of the tests require checking out different branches,
e.g. for testing the effect of loading libraries in a diffrernt order.
There is more info in the README. In particular I checked that nlif still
works with -lnfnetlink coming first
(app will use libnfnetlink's functions).

The nlif functions sit a little uneasily in libnetfilter_queue.
ulogd2 and conntrack-tools both use them so perhaps they would
be better placed in libmnl.
---
 Changes in v3:
 - Remove new kernel header includes as promised in
   https://www.spinics.net/lists/netfilter-devel/msg87916.html
   (The status of the v2 series changed to "Changes Requested":
    I'm guessing that was because of that promise).
 - Remove more libnfnetlink references
 - Rebase on master commit f05b188

 Changes in v2:
 - 11/32 (Fix checkpatch whitespace and block comment warnings) is
   subsumed into previous patches
 - 22/32 becomes 14
 - 21/32 becomes 15
 - 12/32 & 17/32 become 11, but rtnl.c is not copied
 - 14/32 & 16/32 become 12
 - 19/32 & (some of) 32/32 become 13
 - The only changes to linux_list.h are to fix or suppress checkpatch errors.
   There is no attempt to document the circular linked list functions
   and macros, so no changes to build_man.sh. That is how the rest of the
   patches disappear.
 - Other changes are documented in the individual patches

Duncan Roe (15):
  src: Convert nfq_open() to use libmnl
  src: Convert nfq_open_nfnl() to use libmnl
  src: Convert nfq_close() to use libmnl
  src: Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to
    use libmnl
  src: Convert nfq_set_queue_flags(), nfq_set_queue_maxlen() &
    nfq_set_mode() to use libmnl
  src: Convert nfq_handle_packet(), nfq_get_secctx(), nfq_get_payload()
    and all the nfq_get_ functions to use libmnl
  src: Convert nfq_set_verdict() and nfq_set_verdict2() to use libmnl if
    there is no data
  src: Incorporate nfnl_rcvbufsiz() in libnetfilter_queue
  src: Convert nfq_fd() to use libmnl
  src: Convert remaining nfq_* functions to use libmnl
  src: Copy nlif-related files from libnfnetlink
  doc: Add iftable.c to the doxygen system
  src: Convert all nlif_* functions to use libmnl
  include: Use libmnl.h instead of libnfnetlink.h
  build: Remove libnfnetlink from the build

 Make_global.am                                |   2 +-
 configure.ac                                  |   1 -
 doxygen/Makefile.am                           |   1 +
 doxygen/doxygen.cfg.in                        |   6 +
 .../libnetfilter_queue/libnetfilter_queue.h   |  38 +-
 include/libnetfilter_queue/linux_list.h       | 730 ++++++++++++++++++
 .../linux_nfnetlink_queue.h                   |   3 +-
 libnetfilter_queue.pc.in                      |   2 -
 src/Makefile.am                               |   3 +-
 src/iftable.c                                 | 373 +++++++++
 src/libnetfilter_queue.c                      | 543 ++++++++-----
 11 files changed, 1512 insertions(+), 190 deletions(-)
 create mode 100644 include/libnetfilter_queue/linux_list.h
 create mode 100644 src/iftable.c

-- 
2.35.8

