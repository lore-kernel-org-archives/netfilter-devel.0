From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 15:34:42 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091533010.4411@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
 <47FCC0D2.7060306@trash.net> <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr> <47FCC2F4.4030901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39164 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYDINen (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:34:43 -0400
In-Reply-To: <47FCC2F4.4030901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 15:21, Patrick McHardy wrote:
>
> The decoupling of netfilter supported protocols from AF values
> makes sense.
>
> However I think _MAX definitions actually having the value MAX + 1
> is pretty poor style. When you see an array dimensioned as
> [XYZ_MAX] you always have to check whether it is really the maximum
> (and thus a bug) or maximum + 1. So I'd prefer to have MAX really
> be the maximum and use max + 1 for arrays etc.
>
In this case, I'd just follow AF_ suit.
Especially since NAME_MAX=256, PATH_MAX=4096 for example,
_MAX is more often the total size rather than the last element.
(The more even since loops use for (; x < MAX; )
rather than for (; x<= MAX;) as can probably be seen
in a lot of userspace code.)
