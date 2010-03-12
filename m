From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Installing Xtables-Addons
Date: Fri, 12 Mar 2010 20:00:52 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003122000360.11322@obet.zrqbmnf.qr>
References: <2a3692de1003120439k75adfae3ie2bc484152c2b82b@mail.gmail.com>  <alpine.LSU.2.01.1003121347200.32149@obet.zrqbmnf.qr> <2a3692de1003120455o3c00147dm22f7bf1b88b545fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dominik Kaspar <dokaspar.ietf@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47605 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab0CLTAy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:00:54 -0500
In-Reply-To: <2a3692de1003120455o3c00147dm22f7bf1b88b545fe@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-03-12 13:55, Dominik Kaspar wrote:
>
>I have initially tried ./autogen.sh, but gave up on it because an
>error occurred, which made me conclude that ./autogen.sh wasn't the
>right script to run...
>
>Can't exec "libtoolize": No such file or directory at
>/usr/bin/autoreconf line 190.
>Use of uninitialized value $libtoolize in pattern match (m//) at
>/usr/bin/autoreconf line 190.
>configure.ac:9: error: possibly undefined macro: AC_DISABLE_STATIC
>      If this token and others are legitimate, please use m4_pattern_allow.
>      See the Autoconf documentation.
>configure.ac:10: error: possibly undefined macro: AC_PROG_LIBTOOL
>autoreconf: /usr/bin/autoconf failed with exit status: 1

libtoolize is part of libtool.
