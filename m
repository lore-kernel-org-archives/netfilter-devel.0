From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCHv3 2/2][RESEND] Addrtype match extension: limit addrtype
 check on the packet's interface
Date: Fri, 16 Nov 2007 17:49:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711161747290.31083@fbirervta.pbzchgretzou.qr>
References: <119514685071-git-send-email-panther@balabit.hu>
 <11952229272161-git-send-email-panther@balabit.hu>
 <Pine.LNX.4.64.0711161604060.3340@fbirervta.pbzchgretzou.qr>
 <473DB77B.4090206@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49930 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXKPQta (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:49:30 -0500
In-Reply-To: <473DB77B.4090206@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 16 2007 16:30, Laszlo Attila Toth wrote:
>
> xt_addrtype is ok, but the module loading in the userspace part (iptables)
> tries to load the libxt_addrtype.so first

Well that should not be a problem if iptables 1.4.x only has libxt_addrtype.

> and only if it is not succeeded try to load libipt_addrtype.so also the
> latter shared object will never be loaded.
>
> Also it may be better if only the xt_addrtype remains and ipt_addrtype_info is
> used for the old one and xt_addrtype_info for the new one. But it may be
> confusing: ipt_* in the xt_* files...

Will be fixed 'one day' when all the compat code is removed :p

