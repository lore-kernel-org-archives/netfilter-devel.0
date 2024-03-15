Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F17515E89
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 07:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710488035; cv=none; b=JFTcQ9KpXTqmYSwhoGgMORlD3zrQExgwlGy0Fk5v8fZQ3f51AqPyJJ5k8P6/oviFGonttgook+z13A22Zt8k4ixqYcaiBgfZ/RSewQwS7xpF5QzQhF1uasjm4cUkRyScEK8FneUwzlGP3Pm1zbL1sa2AGblNstTLJEPJMQvlUxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710488035; c=relaxed/simple;
	bh=6Fb8vcX6aPFTSlfsCdgc/6kFgaQ5dZcflNelYtSGaE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ItBaG9E9t+XwUwM/NZI8yCENTRdXdtazpiRIW95QDC0hxnfJFQyNPkwCcbExPNM+vZTyz7n2NVnLgCigZ9OVmCC++68Ch4RJXUJ87ldB8o9PxICIK8CLjubgdadD1LPuRWo9KlCwhHlYbabKE6ZQkTz5e7EERCjZRp9YyqMthD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JmHW+eJC; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JmHW+eJC"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dedb92e540so10476905ad.0
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Mar 2024 00:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710488033; x=1711092833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKWOsUBo+hSzf3IoqeVYehhUwpNWy9y5z7lSLtxbcFE=;
        b=JmHW+eJCql6IQrt4L7jsG9WMb3OXDTFWgOCbDDH8yk3U6Qodl+F73Bg9jx+fiFXsSd
         YTusFj8t4kKJ1rJCe7XKA2vZESD83d3n0JR8hw67dWFR49tkWi1GOA9vsS4vm/Aa9vGI
         J0vI5ufzVNED8zblGyh/DFEyWg+nPHf7yXXrhlqk05u4reIdjelu00RF1WrsBwJxDlrD
         3pbVlM3NvtLc3fp/IVGFqQByb0Ru4xQmQTIHGRgp+1Oqy+vGA1oFOoLrcmSuTQV9CYDc
         x03PidVzMRpkYJRuDXE0Pa3jFEHueR8MJ19jHUPu+R1k0a/65miz/9t7c2etOa5MwjLB
         4N1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710488033; x=1711092833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LKWOsUBo+hSzf3IoqeVYehhUwpNWy9y5z7lSLtxbcFE=;
        b=rQXUMlB4/78qvaf6QQKinRONnZrwCnLJhYZfaUhAWi029JgSXzbTO6FhFNE09wokb0
         35YscrNtp7DGpUyqUp9oRssJD+glu1cl2u1kNAns/cI8XhKjRo+dPzLNqTXWxKbdfgOt
         4yYdUq0m7AUgHlexVqr62cX++TzCZhBZVjlGb6j5wBaxkWGeB1h1bTcqvOAqi9/fEPVq
         PSJfo9kgvsf/z4rY8DG/8dnkdz3W/oV67fq7zvmtytjWVTkurlS26yETO39kWRKLlzsj
         jTI5RhuH9nP2YxoL30Nw/2A7IAV8Qcm8tvN2gufA+hyWALYOoSNEBNmeU1l4lDhMzrin
         FzSQ==
X-Gm-Message-State: AOJu0YxLxUAXLsk8DaUxvUcTB4j3p7emL9+rirBONwSxHfU3Yiwau6pQ
	1aP7ZNpb+96OHGuwRoVoSAHhqpthJzloPsdi6ebcJpi/IVp5B42qiT2r/zlL
X-Google-Smtp-Source: AGHT+IF8U5AdBAQRTxLZ49kHgOgAJOMeD5XIreqfi3q/lpUncyQw+VnWZ6GK0x5jPi5jIlrAyB6M7A==
X-Received: by 2002:a17:902:d4d0:b0:1dd:e403:a082 with SMTP id o16-20020a170902d4d000b001dde403a082mr6145505plg.1.1710488032495;
        Fri, 15 Mar 2024 00:33:52 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001dd75d4c78csm3049142plk.221.2024.03.15.00.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 00:33:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 00/32] Convert libnetfilter_queue to not need libnfnetlink
Date: Fri, 15 Mar 2024 18:33:15 +1100
Message-Id: <20240315073347.22628-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
In-Reply-To: <ZcyaQvJ1SvnYgakf@calendula>
References: <ZcyaQvJ1SvnYgakf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

On Wed, Feb 14, 2024 at 11:47:30AM +0100, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
> On Wed, Feb 14, 2024 at 08:07:06AM +1100, Duncan Roe wrote:
> > And no libnfnetlink headers either.
> > Submitted as a single patch because the first change essentially broke
> > it until the job was nearly finished.
>
> This is too large. Can you start with smaller chunks?
>
> For example, use mnl_attr_get_*(), then pick the next target
> incrementally, so there is a chance of evaluating what could break,
> because this conversion to libmnl _cannot_ break existing userspace
> applications, that's the challenge.
>
[SNIP}

This series is a re-spin of
 "Convert libnetfilter_queue to use entirely libmnl functions".

This time, I managed to convert nfq_open_nfnl(). Existing userspace
applications that use nfq_open_nfnl() or any other functions from
libnfnetlink should continue to run just fine.

However many patches you apply, the library will keep working with the
unpatched functions using libnfnetlink.

To assist with patch review, these patches don't contain any documentation
updates except for the nlif subsystem. I have plenty of documentation
updates ready to go but can defer them until you have committed the code.

Cheers ... Duncan.

Duncan Roe (32):
  src: Convert nfq_open() to use libmnl
  src: Convert nfq_open_nfnl() to use libmnl
  src: Convert nfq_close() to use libmnl
  src: Convert nfq_create_queue(), nfq_bind_pf() & nfq_unbind_pf() to
    use libmnl
  src: Convert nfq_set_queue_flags() & nfq_set_queue_maxlen() to use
    libmnl
  src: Convert nfq_handle_packet(), nfq_get_secctx(), nfq_get_payload()
    and all the nfq_get_ functions to use libmnl
  src: Convert nfq_set_verdict() and nfq_set_verdict2() to use libmnl if
    there is no data
  src: Incorporate nfnl_rcvbufsiz() in libnetfilter_queue
  src: Convert nfq_fd() to use libmnl
  src: Convert remaining nfq_* functions to use libmnl
  src: Fix checkpatch whitespace and block comment warnings
  src: Copy nlif-related code from libnfnetlink
  include: Cherry-pick macros and functions that nlif will need
  doc: Add linux_list.h to the doxygen system
  doc: Eliminate doxygen warnings from linux_list.h
  doc: Eliminate doxygen warnings from iftable.c
  whitespace: remove trailing spaces from iftable.c
  include: Use libmnl.h instead of libnfnetlink.h
  src: Convert all nlif_* functions to use libmnl
  src: Delete rtnl.c
  build: Remove libnfnetlink from the build
  include: Remove the last remaining use of a libnfnetlink header
  doc: Get doxygen to document useful static inline functions
  doc: SYNOPSIS of linux_list.h nominates
    libnetfilter_queue/libnetfilter_queue.h
  doc: Move nlif usage description from libnetfilter_queue.c to
    iftable.c
  build: Shave some time off build
  doc: Resolve most issues with man page generated from linux_list.h
  build: Get real & user times back to what they were
  doc: Cater for doxygen variants w.r.t. #define stmts
  doc: Fix list_empty() doxygen comments
  src: Use a cast in place of convoluted construct
  whitespace: Fix more checkpatch errors & warnings

 Make_global.am                                |   2 +-
 configure.ac                                  |   1 -
 doxygen/Makefile.am                           |   5 +
 doxygen/build_man.sh                          |  44 +-
 doxygen/doxygen.cfg.in                        |  11 +-
 .../libnetfilter_queue/libnetfilter_queue.h   |  39 +-
 include/libnetfilter_queue/linux_list.h       | 192 +++++++
 .../linux_nfnetlink_queue.h                   |   3 +-
 libnetfilter_queue.pc.in                      |   2 -
 src/Makefile.am                               |   3 +-
 src/iftable.c                                 | 376 +++++++++++++
 src/libnetfilter_queue.c                      | 515 +++++++++++-------
 12 files changed, 987 insertions(+), 206 deletions(-)
 create mode 100644 include/libnetfilter_queue/linux_list.h
 create mode 100644 src/iftable.c

-- 
2.35.8

