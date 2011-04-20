From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Tue, 19 Apr 2011 23:41:20 -0700
Message-ID: <BANLkTim9Gi-XpwNGZ0RRgtt+PaoRB+Jw0Q@mail.gmail.com>
References: <4D9E45C2.7030805@wildgooses.com>
	<BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com>
	<4D9F41BA.1060509@wildgooses.com>
	<alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr>
	<4D9F98D3.5070802@wildgooses.com>
	<alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
	<4DA0C402.1090809@wildgooses.com>
	<alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
	<BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com>
	<4DA58A73.9030308@wildgooses.com>
	<alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
	<4DA59881.1050501@wildgooses.com>
	<alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>
	<4DA5D346.5030303@wildgooses.com>
	<BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com>
	<BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
	<4DAC67F3.3070503@wildgooses.com>
	<BANLkTikq_5uRpzZWqRA9-VMT4h2Vxjgvpg@mail.gmail.com>
	<BANLkTikyT1VOH9aBJ4=LmM5raL2L8Y+46w@mail.gmail.com>
	<4DADB406.1040606@wildgooses.com>
	<BANLkTi=PqPkDpKu8ej1tCkVNugpecbLHyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52981 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1DTGlV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:41:21 -0400
Received: by wya21 with SMTP id 21so331906wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 23:41:20 -0700 (PDT)
In-Reply-To: <BANLkTi=PqPkDpKu8ej1tCkVNugpecbLHyg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> happen? ie. there should not be any attempted loads of ip_set without
> "iptables -m set" being called (or equivalent).

Actually, are you sure the module is called 'ip_set'?
Kernel iptables match and target extensions are named xt_* or ipt_* or ip6t_*.
If the module is called ip_set and not ipt_set, then maybe we're
seeing some other dependency chain?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=net/netfilter/xt_set.c;h=b3babaed7719b770e02d478091885e7692eac68a;hb=2f666bcf757cb72549f360ef6da02f03620a48b6

contains:

  21 MODULE_LICENSE("GPL");
  22 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
  23 MODULE_DESCRIPTION("Xtables: IP set match and target module");
  24 MODULE_ALIAS("xt_SET");
  25 MODULE_ALIAS("ipt_set");
  26 MODULE_ALIAS("ip6t_set");
  27 MODULE_ALIAS("ipt_SET");
  28 MODULE_ALIAS("ip6t_SET");
(plus the name derived from the filename which is 'xt_set')

so I'm guessing your 'ip_set' was simply a typo and should have been 'ipt_set'.

- Maciej
