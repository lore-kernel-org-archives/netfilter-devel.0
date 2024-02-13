Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A0263102
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707858436; cv=none; b=jnF3XgLoK20+t2XP8Biupci2500Nj+kXeZxT4m4Ng/wg6Kk7intrxkB8W9cE4Jh6qID/1Cu1SHywPlUvW4qR7sDEsjdFjVjQLcebXDFrwwxxXoj7Ze2Splzi8AXrfCG7AJQKbsdho9LWOeFDlrKh+OMSP/SfMNPzYae0mZ64260=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707858436; c=relaxed/simple;
	bh=nV7eq9wAHVfDvt7qL0+onrv80PJJiIkPnk1radNphwg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=flKETqIXbXj5Cya9RjL/oSdVQyB04joHsjrY/VMsxu2XYalmf0T4JaY1tWcUCRj5BbSjYlJQSdHpyONKl3VcWH6c/WF79S/NNYsR67fABSK7aII7CJKXOTpNuEZUOzJjH8FdxIj+D8LmgqRrywnqE+T76YJs7wJpv7bmFYMogMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VWy9YOE1; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VWy9YOE1"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bade847536so285286639f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 13:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707858434; x=1708463234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=10VKPXAnvf3qZBvUqd4FpVZKnjq2J1fu8zE9fgCXgVg=;
        b=VWy9YOE1Js6qsYHu/tvabau9b1N8iU9Rgqt1Vfyt7rA4VHqVhxU8FsRDDvyKxs31up
         8RtRfCz4Hs6itwO+twn55aOl9/18y8Eaawu29rUdXkDCgarX6WPjOnyuNpzFOVeoJAbT
         5w1RkY1VTA2Sp7sEWnEpruft4nXOgp500RKe/04umvv+8zw+KA+zlJ9x05Q/dKpIDOqJ
         FnfqR0ffmjTs7no0zVnQTuTNT1YBz5jbsqShQ6qMFit1fb0ZnU7B29+QFbyTcgR4V4xa
         UMLcAKjyu8GJ62oXQLYUJrZxQuFa/HqfbGQuTzeemoBwdh7wlMir1hql0gfCUCEY09Ay
         3S9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707858434; x=1708463234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10VKPXAnvf3qZBvUqd4FpVZKnjq2J1fu8zE9fgCXgVg=;
        b=HYyUke5apNq8DrrPwkteHoGYR2TrO6BRtjwoev7aUDlY3sPZ75NwtSEpEWzCbpvo7e
         1v4DlTD/EPMqKPY+gig8YEIA4v3PG8jAwfJ5MiDQ7nt5cPQW0bG8c4cqbOuCNggChM+W
         /FjNiVIAO21ehLyQxYO+/F49Sj+HG0GNPpMqnroTjQY1ApKWlvMRMuOpQ4DxGsnwk7pW
         bOxXS7vVw6qUfpBqWZ5mLNZeduKLg9HEJ+DroQHZVA03w/PDPN1FTSOTKsDx8i+SaE2b
         1eMzo1u7xC3wKZ1zALIrIljXqeSn9M5HZ8WSbPB5DVvzb47Z06T3Z5+avidYT3MXAsdr
         1X7Q==
X-Gm-Message-State: AOJu0YxvnEWtuPb9g0RTmBwkrjEamW7NuyOlobKkugCr2eQ3BSp301lq
	WqnNG/FNmkekf4UG3peqq6U6DLxQYXN//c6kEGiTTcwsrpEJbuYp
X-Google-Smtp-Source: AGHT+IGKrfEaowCFVmfpKBd5rFGi1HVqltPQS4QXEqnLJKDrLMhTGpJLrzhxVTJeNnEzGUrxLYqAAw==
X-Received: by 2002:a92:c5a1:0:b0:363:c796:7736 with SMTP id r1-20020a92c5a1000000b00363c7967736mr843371ilt.28.1707858433751;
        Tue, 13 Feb 2024 13:07:13 -0800 (PST)
Received: from slk15.local.net (pa49-184-82-110.pa.vic.optusnet.com.au. [49.184.82.110])
        by smtp.gmail.com with ESMTPSA id s26-20020a65691a000000b005dbe22202fbsm2497543pgq.42.2024.02.13.13.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 13:07:13 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] Convert libnetfilter_queue to use entirely libmnl functions
Date: Wed, 14 Feb 2024 08:07:05 +1100
Message-Id: <20240213210706.4867-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This libnetfilter_queue does not use any libnfnetlink functions or headers.

The major revision of libnetfilter_queue.so will have to increase because
nfq_open_nfnl() is deleted.

I've never used `./autogen.sh distrib` so have left the libnfnetlink reference.
Can it be removed?

The library provides all libnfnetlink functions mentioned in documentation
or required to implement these functions:

 - nlif_open(), nlif_close(), nlif_fd(), nlif_query(), nlif_catch(),
    nlif_index2name() & nlif_get_ifflags()
 - (macro) __be64_to_cpu
 - nfnl_rcvbufsiz()

In the absence of feedback, I added these former libnfnetlink functions to
libnetfilter_queue and left libmnl unchanged.

As always, the documentation could still be improved. Next to do might be a
refresh of the "Performance" section on the Main page.

Cheers ... Duncan.

Duncan Roe (1):
  Convert libnetfilter_queue to use entirely libmnl functions

 Make_global.am                                |   2 +-
 configure.ac                                  |   1 -
 doxygen/Makefile.am                           |   5 +
 doxygen/build_man.sh                          |  44 +-
 doxygen/doxygen.cfg.in                        |   8 +-
 .../libnetfilter_queue/libnetfilter_queue.h   |  47 +-
 include/libnetfilter_queue/linux_list.h       | 185 +++++
 .../linux_nfnetlink_queue.h                   |   1 -
 libnetfilter_queue.pc.in                      |   1 -
 src/Makefile.am                               |   3 +-
 src/extra/pktbuff.c                           |  27 +-
 src/iftable.c                                 | 391 ++++++++++
 src/libnetfilter_queue.c                      | 696 ++++++++++--------
 src/nlmsg.c                                   |  46 +-
 14 files changed, 1102 insertions(+), 355 deletions(-)
 create mode 100644 include/libnetfilter_queue/linux_list.h
 create mode 100644 src/iftable.c

-- 
2.35.8

