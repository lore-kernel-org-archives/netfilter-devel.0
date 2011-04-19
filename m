From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Tue, 19 Apr 2011 02:03:42 -0700
Message-ID: <BANLkTikyT1VOH9aBJ4=LmM5raL2L8Y+46w@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36145 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1DSJDn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:03:43 -0400
Received: by wya21 with SMTP id 21so4618293wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 02:03:42 -0700 (PDT)
In-Reply-To: <BANLkTikq_5uRpzZWqRA9-VMT4h2Vxjgvpg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

And the "Don't load ip6?_tables module when already loaded" patch is
now available in upstream git...

That patch combined with my previous patch should solve all your woes.
If they don't... let me know.

- Maciej
