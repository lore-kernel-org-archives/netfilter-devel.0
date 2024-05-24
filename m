Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0E763E4
	for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2024 05:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716529071; cv=none; b=awnvc7TlaL17f7WnYQKRYJCMTAkRxMSF/4iQciiKs2o0QOHbR6PXTwkjG80dSDOFe0gbB9GEEi+gxVEix2ZYJ9fUApHD21d0B+PM4YHGEYbR2632ZBlrtpXnAy6EW7IqIDUkYZ8XNoCir8yLsmrBgsd5S8WQJAgDM1omQhPpKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716529071; c=relaxed/simple;
	bh=tlS/im+etms+Lo0Y35tlKxjAEU4xvaqKGmvceLEKisc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UGofK0/jHatvk4s1aJY11kpvJUd8mRsn+2Lbg+RjfjXI0CMP7FuIpX8e48zLV010u2O4rw8FVooJzsz0OiYdCYeza8mElkkwQ1ePmLV0QjF3aZ3rcYP3IlRRITxSp8h/hgmpqJ7m2aMTycom4ETGaiNo+6uGVgVBuDfk7e7zPMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ffRtSnH6; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ffRtSnH6"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c9cc66c649so3927526b6e.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 22:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716529068; x=1717133868; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=PqCImmIgCl6ICqPAO0GX7TmOadr9EYMD24t89OwbqLE=;
        b=ffRtSnH62Z4TOyASspXHV/JZ0xv2tp+WLXl8NPr7CDVXgF8se+cOz5+TXL/6diirdn
         Nionfq0074j8w03RDsAz+OKQpKoz5nr0L+r6xx8URd4axdglmeFoikaHcKN59CGnUCKN
         FpslcwfEQfI6jknT/fqZd12SD/shXt0dtvlZvIphV3dVGNBOfxoRKnXG+SReYj4GQtXD
         sg+n5D3hv7LMyXoPgfJKY2jQGG1UV+DD+/Zcj+AMYNMV3kHia3yr6P54QiZF8+A0E4SU
         4D0z7VcdluY9EnMOYd68s7+boBy6ucYkG7MV8j5QrsXEBXLld4I0uolggv+zWLXczvJ9
         zO5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716529068; x=1717133868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqCImmIgCl6ICqPAO0GX7TmOadr9EYMD24t89OwbqLE=;
        b=VcAQGN7nmGAazBHm2ep4+2PT/E+EdJAcTHKGEaIq4XUBavzYJcRrGWHSN4UU1pJh2j
         /2ALWQh5n+cPJWUymlFiKnwzW5UcPiWrfCwUBC+uitgAoMSDROZMOp5n4y1arQvpXY7c
         a9JUju1ZuKJscMpbPNSfb4/8fHKbrCUD9mGyvTw3TlsdRhhzeYEwWoA/FXAh3XKuvhqG
         8xYqY3WQ+4iKA3DpV/TUAGzHdTgLwD2WHuIsIwJ1CQkJmFVMnOR7UfZtTgywXti1DpDG
         l+uc844kDjfDL0HFEH0bhXuwswHa9FffYjhhCBfNMmvYhMN0GA3IpXmET0UexWjKz/Zh
         Ql+Q==
X-Gm-Message-State: AOJu0Yz8XKF1P+OWhlWfm1WOVwGW+iZLtpwZVr4GkKSw7yhIHDGam9Yb
	vYOtwOMExS1dMLxXjVD/ro23j4IxVfvYQwz81k/pVinbZ4xupY65y0ceCQ==
X-Google-Smtp-Source: AGHT+IGlnllf0FE3k93dixuwopAUzXwSj0kfnEohF1UQRkh8q0LbxAE6sqVLIuE6N6WtFqrj4mXt4A==
X-Received: by 2002:a05:6808:274c:b0:3c9:6bbe:53a8 with SMTP id 5614622812f47-3d1a5f21ad8mr1461618b6e.27.1716529067805;
        Thu, 23 May 2024 22:37:47 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f8fcbe9f61sm460374b3a.110.2024.05.23.22.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 22:37:47 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: [PATCH libnetfilter_queue v2 00/15] Convert libnetfilter_queue to not need libnfnetlink
Date: Fri, 24 May 2024 15:37:27 +1000
Message-Id: <20240524053742.27294-1-duncan_roe@optusnet.com.au>
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

