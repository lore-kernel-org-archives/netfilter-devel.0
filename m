From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables-addons link error
Date: Sat, 14 Apr 2012 03:58:33 +0100
Message-ID: <4F88E7D9.7000508@googlemail.com>
References: <4F7BB331.7000808@googlemail.com> <alpine.LNX.2.01.1204050724100.6040@frira.zrqbmnf.qr> <4F7D7B8F.3000705@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44328 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2DNC6j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:58:39 -0400
Received: by wibhq7 with SMTP id hq7so3535945wib.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Apr 2012 19:58:37 -0700 (PDT)
In-Reply-To: <4F7D7B8F.3000705@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Thanks, I'll deploy it later on today.
When I try to link/build xtables-addons 1.42 against kernel 3.3.1 I get this:

WARNING: /lib/modules/3.3.1-3.fc13.i686/extra/xtables-addons/xt_ECHO.ko needs unknown symbol ip6_dst_hoplimit
WARNING: /lib/modules/3.3.1-3.fc13.i686/extra/xtables-addons/xt_ECHO.ko needs unknown symbol ip6_local_out
WARNING: /lib/modules/3.3.1-3.fc13.i686/extra/xtables-addons/xt_ECHO.ko needs unknown symbol ip6_route_output

I do not have ipv6 enabled at all, maybe that's why this is happening, though I did not have this problem with earlier versions.
