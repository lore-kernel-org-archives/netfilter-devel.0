From: Dominik Kaspar <dokaspar.ietf@gmail.com>
Subject: Re: Installing Xtables-Addons
Date: Fri, 12 Mar 2010 13:55:39 +0100
Message-ID: <2a3692de1003120455o3c00147dm22f7bf1b88b545fe@mail.gmail.com>
References: <2a3692de1003120439k75adfae3ie2bc484152c2b82b@mail.gmail.com>
	 <alpine.LSU.2.01.1003121347200.32149@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46181 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0CLMzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:55:41 -0500
Received: by bwz1 with SMTP id 1so996079bwz.21
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Mar 2010 04:55:40 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1003121347200.32149@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

I have initially tried ./autogen.sh, but gave up on it because an
error occurred, which made me conclude that ./autogen.sh wasn't the
right script to run...

Can't exec "libtoolize": No such file or directory at
/usr/bin/autoreconf line 190.
Use of uninitialized value $libtoolize in pattern match (m//) at
/usr/bin/autoreconf line 190.
configure.ac:9: error: possibly undefined macro: AC_DISABLE_STATIC
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
configure.ac:10: error: possibly undefined macro: AC_PROG_LIBTOOL
autoreconf: /usr/bin/autoconf failed with exit status: 1

Somehow I was missing "libtoolize"... no idea what that is, but I
could now install it and the xtables-addons have successfully
compiled.

Cool... now I can set up iptables rules with RAWDNAT, which was my
primary intention. Sorry for the rash question to the mailing list ;-)

Greetings,
Dominik
