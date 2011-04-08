From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Thu, 7 Apr 2011 17:47:44 -0700
Message-ID: <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
References: <4D9E45C2.7030805@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56174 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab1DHAvO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:51:14 -0400
Received: by wya21 with SMTP id 21so2686205wya.19
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Apr 2011 17:51:13 -0700 (PDT)
In-Reply-To: <4D9E45C2.7030805@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 7, 2011 at 16:16, Ed W <lists@wildgooses.com> wrote:
> Hi, I am using a relatively low powered (embedded) platform and I hav=
e a
> significant performance problem due to slow "modprobe" performance.
>
> I have my kernel compiled without modules. =C2=A0My modprobe takes a =
little
> under 1ms to execute. =C2=A0"iptables" appears to try and modprobe so=
me 21
> match/target modules. =C2=A0As a result, even "iptables -h" takes aro=
und 14ms
> to run. =C2=A0This is adding some substantial time to my firewall set=
up time
> (hacking out the modprobes reduces run time from the 14ms to near zer=
o,
> ie it's 90+% of my runtime)
>
> I have dug through the code a bit and the first thing I notice is tha=
t
> there is no --modprobe option actually parsed for, and the undocument=
ed
> "-M" option doesn't appear to pass through to xtables.c? (I thought
> about simply lying about the modprobe binary name)
>
> My next thought was to collect all the modprobes and run them with a
> single execution (modprobe -a). However, it's not clear to me whether
> it's important that the modprobe occurs in the middle of xtables.c /
> compatible_revision() ?
>
> The final thought is whether it's possible to notice that a module is
> already loaded and skip the modprobe call altogether? (/proc/modules =
is
> not enough because the module could be built into the kernel)
>
> Does someone have any ideas on how I can finesse these constant (and
> expensive in my case) modprobes each time we run the iptables command=
?

Could you try with an iptables built from iptables git master branch?
I believe a recent change I submitted (delayed initialization of
target/matches to prevent module autoloading) may actually fix your
problem.

- Maciej
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
