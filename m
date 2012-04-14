From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons link error
Date: Sat, 14 Apr 2012 10:28:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204141007590.1110@frira.zrqbmnf.qr>
References: <4F7BB331.7000808@googlemail.com> <alpine.LNX.2.01.1204050724100.6040@frira.zrqbmnf.qr> <4F7D7B8F.3000705@googlemail.com> <4F88E7D9.7000508@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38150 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab2DNI2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:28:33 -0400
In-Reply-To: <4F88E7D9.7000508@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-04-14 04:58, Mr Dash Four wrote:

>> Thanks, I'll deploy it later on today.
>When I try to link/build xtables-addons 1.42 against kernel 3.3.1 I get this:
>
>WARNING: /lib/modules/3.3.1-3.fc13.i686/extra/xtables-addons/xt_ECHO.ko needs unknown symbol ip6_dst_hoplimit
>WARNING: /lib/modules/3.3.1-3.fc13.i686/extra/xtables-addons/xt_ECHO.ko needs unknown symbol ip6_local_out
>WARNING: /lib/modules/3.3.1-3.fc13.i686/extra/xtables-addons/xt_ECHO.ko needs unknown symbol ip6_route_output
>
>I do not have ipv6 enabled at all, maybe that's why this is happening, though I did not have this problem with earlier versions.

As a temporary mitigation, please set build_ECHO=n in the mconfig file.
