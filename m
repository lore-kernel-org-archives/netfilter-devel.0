From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: 0/8 Netfilter patches (group 2)
Date: Tue, 8 Apr 2008 18:08:37 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804081803370.2229@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36404 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbYDHQIi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:08:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Those other 8 loose mails (git-send-email has too many flags to get
it right every time) make up the second group (of two) of kernel
patches.

=E2=8B=AE
=E2=95=9F [NETFILTER]: Rename ipt_recent to xt_recent
=E2=95=9F [NETFILTER]: xt_recent: IPv6 support
=E2=95=9F [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign a non-cl=
ashingvalue
=E2=95=9F [NETFILTER]: Implement AF_UNSPEC as a wildcard for extensions
=E2=95=9F [NETFILTER]: Give AF-independent extensions an arpt_ alias
=E2=95=9F [NETFILTER]: Make Ebtables use Xtables infrastructure
=E2=95=9F [NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into one functi=
on
=E2=95=9F [NETFILTER]: Deploy a prefix_length-to-network mask mapping t=
able
=E2=8B=AE
=E2=95=99=E2=94=80[master]
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
