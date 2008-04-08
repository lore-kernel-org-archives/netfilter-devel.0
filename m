From: Patrick McHardy <kaber@trash.net>
Subject: Re: 0/8 Netfilter patches (group 2)
Date: Tue, 08 Apr 2008 18:14:02 +0200
Message-ID: <47FB99CA.5060002@trash.net>
References: <alpine.LNX.1.10.0804081803370.2229@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43551 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYDHQOF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:14:05 -0400
In-Reply-To: <alpine.LNX.1.10.0804081803370.2229@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Those other 8 loose mails (git-send-email has too many flags to get
> it right every time) make up the second group (of two) of kernel
> patches.
>=20
> =E2=8B=AE
> =E2=95=9F [NETFILTER]: Rename ipt_recent to xt_recent
> =E2=95=9F [NETFILTER]: xt_recent: IPv6 support
> =E2=95=9F [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign a non-=
clashingvalue
> =E2=95=9F [NETFILTER]: Implement AF_UNSPEC as a wildcard for extensio=
ns
> =E2=95=9F [NETFILTER]: Give AF-independent extensions an arpt_ alias
> =E2=95=9F [NETFILTER]: Make Ebtables use Xtables infrastructure
> =E2=95=9F [NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into one func=
tion
> =E2=95=9F [NETFILTER]: Deploy a prefix_length-to-network mask mapping=
 table
> =E2=8B=AE
> =E2=95=99=E2=94=80[master]

Small suggestion for improvement (don't worry, your series
is fine :)): the best ordering for all these patches would
have been:

Set 1: boolean conversions
Set 2: length match (shouldn't have dependencies)
Set 3: recent match (also shouldn't have dependencies)
Set 4: prefix table
Set 5: TCPMSS target
Set 6: ARP-tables patches

This way each logical set of changes can be discussed
seperately. I'd also send things that need additional
userspace-patches (like length) as kernel patch 1-n +
iptables patch 1-n, but closely together.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
