From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCHv3 2/2][RESEND] Addrtype match extension: limit addrtype
 check on the packet's interface
Date: Fri, 16 Nov 2007 16:06:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711161604060.3340@fbirervta.pbzchgretzou.qr>
References: <119514685071-git-send-email-panther@balabit.hu>
 <11952229272161-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49634 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbXKPPG3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:06:29 -0500
In-Reply-To: <11952229272161-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 16 2007 15:22, Laszlo Attila Toth wrote:
>Addrtype match has a new revision (1), which lets address type checking
>limited to the interface the current packet belongs to. Either incoming
>or outgoing interface can be used depending on the current hook. In the
>FORWARD hook two maches should be used if both interfaces have to be checked.

Hey would not it be cool if this was bumped to xt_addrtype,
using .revision=0 with ipt_addrtype_info (with the old functionality),
and let .revision=1 use xt_addrtype_info (with the new functionality).
Much like the recently posted xt_tos/xt_owner.

>-struct ipt_addrtype_info {
>+enum
>+{
>+	IPT_ADDRTYPE_INVERT_SOURCE	= 0x0001,
>+	IPT_ADDRTYPE_INVERT_DEST	= 0x0002,
>+	IPT_ADDRTYPE_LIMIT_IFACE_IN	= 0x0004,
>+	IPT_ADDRTYPE_LIMIT_IFACE_OUT	= 0x0008,
>+};
>+
>+struct ipt_addrtype_info_v1 {
>+	u_int16_t	source;		/* source-type mask */
>+	u_int16_t	dest;		/* dest-type mask */
>+	u_int32_t	flags;
>+};
>+
>+struct ipt_addrtype_info_v0 {

Is it actually ok to change ipt_addrtype_info into ipt_addrtype_info_v0?
It does not break binary compat, but source-level compat.

