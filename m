From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Thu, 14 Apr 2011 00:13:28 -0700
Message-ID: <BANLkTimNc7_XyEoX2usooZLsYyYTn4OnUA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37565 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab1DNHNa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:13:30 -0400
Received: by wya21 with SMTP id 21so1125849wya.19
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2011 00:13:28 -0700 (PDT)
In-Reply-To: <BANLkTincEe0_Fj89wJecgR5Up7CvS6ERtw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Note that: -M '' is -M followed by a space and two single quotes.

Furthermore, note that with -M '', you will want to modprobe ip_tables
or modprobe ip6_tables manually first at system startup (or build them
into the kernel), since those modules don't autoload (hence why
iptables tries to load them).

I wonder if there's an easy way iptables userspace could detect
whether these modules are already loaded (or compiled into the
kernel), and not even try to load them, if so...

- Maciej
