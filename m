From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: static build breakage - 1.4.16.2.
Date: Mon, 8 Oct 2012 14:09:11 -0700
Message-ID: <CAHo-OowBbi-qoX0tQ-__Kmq2r-md8RFeDneTOCJEb_ZNjS30fQ@mail.gmail.com>
References: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62545 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2JHVJM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:09:12 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so5229550vcb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Oct 2012 14:09:11 -0700 (PDT)
In-Reply-To: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

extensions/GNUmakefile.in:118:libext.a: initext.o ${libext_objs}

extensions/GNUmakefile.in:61:@ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}

extensions/GNUmakefile.in:48:pfx_objs      := $(patsubst
%,libxt_%.o,${pfx_build_mod})

extensions/GNUmakefile.in:41:pfx_build_mod := $(patsubst
${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
extensions/GNUmakefile.in:42:pfx_build_mod += NOTRACK state
extensions/GNUmakefile.in:45:pfx_build_mod := $(filter-out
@blacklist_modules@,${pfx_build_mod})

so I guess that explains why it fails, but no idea what the right fix is.
