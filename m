From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: nftables: improve build system
Date: Mon, 13 Jan 2014 10:47:24 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1401131035120.16954@nerf08.vanv.qr>
References: <1389604070-12068-1-git-send-email-jengelh@inai.de> <20140113091250.GB14601@macbook.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:60841 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaAMJrZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:47:25 -0500
In-Reply-To: <20140113091250.GB14601@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2014-01-13 10:12, Patrick McHardy wrote:
>
>>       build: remove unused checks
>
>Why aren't we instead evaluating the results?

I don't know - I did not write those lines in the first place. A
reasonable hypothesis is that this is just old boilerplate copied
from somewhere else rather than actually looking for what the
commands executed by make really need.

=46urthermore, like a lot of NF software, it is tied to Linux where the
existence of arpa/inet.h, fcntl.h, malloc(3), and so on is
pretty much guaranteed.

The only point to check for absence of stdint.h is when at the same
time, the code provides alternative ways to get what it needs (like a
hand-crafted typedef unsigned char uint8_t) - which are not present
either. So checking for stdint.h is rather useless.

>>       build: rename conflicting parser.h instances
>
>The changelog mentions something about -I but no further explanation a=
bout
>why this change is done and the effects.

How so? Commit says:

	If -I. is on the command line =E2=80=A6

and -I. is on the command line with autoconf (more precisely,
-I${srcdir} -I${builddir} -I${path_to_config_h} is).

	=E2=80=A6 #include <parser.h> becomes (=3Dmatches) ./parser.h
	instead of ../include/parser.h.

Basically you never ever want to have a header with the same include
path. Even #include <regex.h> is prone to ambiguity if you had
-I/usr/include/boost (which you should not of course, but people
do all kinds of weird things sometimes), suddenly matching
/usr/include/boost/regex.h instead of /usr/include/regex.h.

It's all about distributions, and it takes a regular packager to know.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
