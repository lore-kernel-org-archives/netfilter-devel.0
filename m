From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Centos 6.5 xtables Addons
Date: Thu, 28 Aug 2014 14:57:06 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1408281456240.28518@nerf08.vanv.qr>
References: <CACuimbnEMuR3jn6RGMQg=_nMgKeZ0HLpxZ+LrCw5tZiuxrg5qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Glenn Sams <pyromanci@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:40091 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaH1M5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:57:08 -0400
In-Reply-To: <CACuimbnEMuR3jn6RGMQg=_nMgKeZ0HLpxZ+LrCw5tZiuxrg5qA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2014-08-14 15:42, Glenn Sams wrote:

>-A INPUT -m geoip ! --src-cc US -j REJECT --reject-with icmp-net-unreachable
>
>But when I did, I got this message:
>[...]
>xt_geoip: unable to load 'US' into memory: -12
>xt_geoip: unable to load 'CN' into memory: -12
>xt_geoip: unable to load 'AW' into memory: -12

12 is ENOMEM - Out of memory.
