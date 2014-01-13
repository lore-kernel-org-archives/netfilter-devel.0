From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: nftables: improve build system
Date: Mon, 13 Jan 2014 11:56:05 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1401131152490.18579@nerf08.vanv.qr>
References: <1389604070-12068-1-git-send-email-jengelh@inai.de> <20140113091250.GB14601@macbook.localnet> <alpine.LSU.2.11.1401131035120.16954@nerf08.vanv.qr> <20140113095646.GC15457@macbook.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:39622 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaAMK4I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:56:08 -0500
In-Reply-To: <20140113095646.GC15457@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2014-01-13 10:56, Patrick McHardy wrote:

>On Mon, Jan 13, 2014 at 10:47:24AM +0100, Jan Engelhardt wrote:
>> >
>> >Why aren't we instead evaluating the results?
>>=20
>> I don't know - I did not write those lines in the first place. A
>> reasonable hypothesis is that this is just old boilerplate copied
>> from somewhere else rather than actually looking for what the
>> commands executed by make really need.
>
>That was not my question. I asked why we're not evaluating *instead* o=
f
>removing them.

Evaluation would be redundant: nftables is not (meant to be) portable!:

>> Furthermore, like a lot of NF software, it is tied to Linux where th=
e
>> existence of arpa/inet.h, fcntl.h, malloc(3), and so on is
>> pretty much guaranteed.




>> How so? Commit says:
>>=20
>> 	If -I. is on the command line =E2=80=A6
>>=20
>> and -I. is on the command line with autoconf (more precisely,
>> -I${srcdir} -I${builddir} -I${path_to_config_h} is).
>>=20
>> 	=E2=80=A6 #include <parser.h> becomes (=3Dmatches) ./parser.h
>> 	instead of ../include/parser.h.
>>=20
>> Basically you never ever want to have a header with the same include
>> path. Even #include <regex.h> is prone to ambiguity if you had
>> -I/usr/include/boost (which you should not of course, but people
>> do all kinds of weird things sometimes), suddenly matching
>> /usr/include/boost/regex.h instead of /usr/include/regex.h.
>>=20
>> It's all about distributions, and it takes a regular packager to kno=
w.
>
>Jan, the changelog simply needs a description what is wrong

Naming two header files the same.

>why it is wrong

When same-name header files can both potentially be in the include=20
search path, it creates an ambiguity as to which one is chosen.

>what is changed.

The filename.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
