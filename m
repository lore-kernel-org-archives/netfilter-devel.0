Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14C47CF3E
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041377; cv=none; b=XiZkjpr5vw8MHlyKQ7j9jZqyaMnLbenGypFq++MSm5Z6F2XuqxnaVnd9w+MbQdVT8QDJb7vFJFZpSf36hMkygXXucmOHBo2il5XttFMjt8AjdxynuCbC0+j7BawdNKYTKs8fsFuEVRTgJ2XvJYRpFi74gISWHlWYpUkW5DmqJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041377; c=relaxed/simple;
	bh=5nmRYZynlArPuyC8lVqxNrGVgSWjwaV698vV24Ag1Yc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=CvHA4J7tqg+IQslWfUFcEpbMs+VqWWQOGVuCACpp5NtYfxv58jDmLH4hjj5KsHorgl+rvCLn1JHFKrKR/xcLV0H456INjFPRrWOTwLUJaiNkUP87P3gTshtsMH0rqtRUqQmqf4PqiCXj7P/ahhVDFMZ0fl37Zd/BkbAuy3WBAcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FHWdey2p; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FHWdey2p"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52efd855adbso2630526e87.2
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2024 07:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723041373; x=1723646173; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kwBbHC26Y/awvQjGAgsxk7EpMn1LLNd7/qJjz1NC74c=;
        b=FHWdey2pYnV/jSJ47arh8rV9+Gaoq0Un3gJ+SCEZh/eOK1hdAwpgYG9uvyaJ2ihJTq
         +wsYsNba3i71kpFnsXn8yxQbS10jerbFLKSEsbTNXgDC4o+nfduUNP7FNRYdL0WcJOX4
         bfIGT5Rs9PFrdjoCS/P8R37u9Q1mXSpMPKEonyCs3kBBKJD1WOvGUauWRB55anPMakg0
         lGGQkbpyt6u0p7Xup3GGXiRyJezj4YsGv5kJ4nUdCC9MQPjKlJ292cxe6489EZo86rFn
         0Kfq0h7SqOZw17Y4jwptu+83fXZKDtBU3Cs2BCCXi/H59lnyoBkqi8QIE1ENsXk047Xw
         IB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723041373; x=1723646173;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kwBbHC26Y/awvQjGAgsxk7EpMn1LLNd7/qJjz1NC74c=;
        b=fuEvPOnhQwXTBNVKk/RqYfGYBZEVvq+5ybj61rVc8qRtqBtUCciQ4hzm1rcZpvRKZT
         dN+f+ntaHM0hgnKpi6idQRQ5jfjzV15uBcTSZgB9qF11h8AxgOB5Nu5h8fCGLkljE6vz
         7CKS4hj7Uer7n1eLPTewBwaTPGyC12BQ6nOwce2kRgMKiTC7wfcvgRCwSeq1lFNxP4A5
         ayuaNr8Vt6MPFT0jycbKol1gmcGPUAYyEa0Jg2uIbk7MbKeLGdEPfyMATf1nSZWN9Re4
         9W2TZrquzvnpIAS6Iq3OUqyag624U3XxRD1IAqxlyPGHv8beJYTKeqtr6WHpkJVD2seg
         C8GA==
X-Gm-Message-State: AOJu0YxSovV5vep1OzjchZZBY8l4rR2pHjHGEqP7pwUA+BfprytbFHSG
	JKh7RdiiDu0jRavuRK3Jofkw1W9FtampmagwcTu8FwxM0weJR9rRRiXU2VPzm5ztf9mL3mUa764
	jWfiPU832dgUZ9Vru+A4btv/mOLXeH8xr
X-Google-Smtp-Source: AGHT+IFZdvCsYVO1OU5YQQJIXOAcyMkSueVNiUbIbaacXge+4kUblL7vrzcNK5Df88n4Jqzj7D0FejeNBH+UjZMemRE=
X-Received: by 2002:a05:6512:104a:b0:530:b7f4:3aaa with SMTP id
 2adb3069b0e04-530bb3b4590mr12335198e87.52.1723041373011; Wed, 07 Aug 2024
 07:36:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: josh lant <joshualant@googlemail.com>
Date: Wed, 7 Aug 2024 15:36:01 +0100
Message-ID: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
Subject: iptables: compiling with kernel headers
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Apologies in advance for the long post=E2=80=A6 I wonder if someone could h=
elp
me understand the architecture of the iptables codebase, particularly
its use of kernel headers=E2=80=A6

**Background**

I am trying to build for the Morello architecture, which uses
hardware-based capabilities for memory safety, effectively extending
pointer size to 128b, with 64b address and then added bounds/type
information etc in the upper 64b.

Because of this I have had to modify a number of the kernel uapi
headers. If you would like some more context of why I am having to do
this, please see the discussion in this thread:

https://op-lists.linaro.org/archives/list/linux-morello@op-lists.linaro.org=
/thread/ZUWKFSJDBB2EIR6UMX3QU63KRZFN7VTN/

TL;DR- The uapi structures used in iptables which hold kernel pointers
are not compatible with the ABI of Linux on the Morello architecture,
since currently kernel pointers are 64b, but in userspace a * declares
a capability of size 128b. This causes a discrepancy between what the
kernel expects and what is provided inside some of the netlink
messages, due to the alignment of structures now being 16B. As a
result I have had to modify any kernel pointer inside uapi structs to
be unsigned longs, casting them when used inside the kernel.

Does anyone have any opinion on this method of changing uapi structs
to not contain kernel pointers? Does simply changing them to unsigned
long seem sensible, or am I likely to come up against some horrible
problems I have not yet realised?

**Issue**

When I try to compile iptables using =E2=80=94with-kernel, or =E2=80=94with=
-ksource, I
get this error:

In file included from =E2=80=A6/iptables-morello/extensions/libxt_TOS.c:16:
In file included from =E2=80=A6/iptables-morello/extensions/tos_values.c:4:
In file included from =E2=80=A6/kernel-source/include/uapi/linux/ip.h:22:
In file included from
=E2=80=A6/usr/src/linux-headers-morello/include/asm/byteorder.h:23:
In file included from
=E2=80=A6/kernel-source/include/uapi/linux/byteorder/little_endian.h:14:
=E2=80=A6/kernel-source/include/uapi/linux/swab.h:48:15: error: unknown typ=
e
name '__attribute_const__'

I see that this error arises because when I set the =E2=80=94with-kernel fl=
ag
libxt_TOS.c is being compiled against ./include/uapi/linux/ip.h. But
when I compile without that flag, the -isystem flag value provides the
./include/linux/ip.h.

**Questions**

I see in the configure.ac script that setting this flag changes the
includes for the kernel, putting precedence on the uapi versions of
the headers. This was introduced in commit
59bbc59fd2fbbb7a51ed19945d82172890bc40f9 specifically in order to fix
the fact that =E2=80=94with-kernel was broken. However I read in the INSTAL=
L
file:

 =E2=80=9Cprerequisites=E2=80=A6  no kernel-source required =E2=80=9C,
and
=E2=80=9C--with-ksource=3D =E2=80=A6 Xtables does not depend on kernel head=
ers anymore=E2=80=A6
probably only useful for development.=E2=80=9D

So I wonder, is this =E2=80=94with-kernel feature seldom used/tested and no
longer working in general? Or could my issue be due to the fact that
this __attribute_const__ is a GCC specific directive and I use clang,
and this is not being picked up properly when running configure?

What I thought might be a solution to compile with my modified headers
would be to simply copy over and replace the relevant headers which
are present in the ./include/linux/ directory of the iptables source
repo. However, even with unmodified kernel headers this throws up its
own issues, because I see that there are differences between some of
these headers in the iptables source and those in the kernel source
itself.

One example of these differences is in xt_connmark.h, leading to
errors with duplication of declarations when compiling
libxt_CONNMARK.c using the headers from the kernel source=E2=80=A6 In the
iptables source the libxt_CONNMARK.c file defines D_SHIFT_LEFT.
However, in the latest version of xt_connmark.h in the kernel, this
enum definition is in the header, so it needs to be removed from the
iptables libxt_CONNMARK.c file. The version of the header in the
iptables source has not been updated to correspond to the current
kernel header version.

commit for xt_connmark.h in kernel source:

commit 472a73e00757b971d613d796374d2727b2e4954d
Author: Jack Ma <jack.ma@alliedtelesis.co.nz>
Date:   Mon Mar 19 09:41:59 2018 +1300

+enum {
+       D_SHIFT_LEFT =3D 0,
+       D_SHIFT_RIGHT,
+};
+

commit for libxt_CONNMARK.c in iptables source:

commit db7b4e0de960c0ff86b10a3d303b4765dba13d6a
Author: Jack Ma <jack.ma@alliedtelesis.co.nz>
Date:   Tue Apr 24 14:58:57 2018 +1200

+enum {
+       D_SHIFT_LEFT =3D 0,
+       D_SHIFT_RIGHT,
+};
+

I suppose I am generally confused about why iptables uses its own
bespoke versions of kernel headers in its source, that do not marry up
with those actually in the kernel repo. Are the headers different for
backwards compatibility or portability or such?

Many thanks,

Josh
