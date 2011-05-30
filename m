From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 3/5] build: fix absence of xml translator in IPv6-only builds
Date: Mon, 30 May 2011 13:57:33 +0200
Message-ID: <BANLkTimUtbkVghwChBArxec-UvH5pDfz=A@mail.gmail.com>
References: <1306750686-11595-1-git-send-email-jengelh@medozas.de>
	<1306750686-11595-4-git-send-email-jengelh@medozas.de>
	<BANLkTik2r-SqtUMVBRcKFngPTzgMUJruzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:53199 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1E3L5e convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2011 07:57:34 -0400
Received: by pxi2 with SMTP id 2so2434910pxi.10
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2011 04:57:33 -0700 (PDT)
In-Reply-To: <BANLkTik2r-SqtUMVBRcKFngPTzgMUJruzg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ie. this commit, in xtables-multi.c should probably change:

       {"iptables-xml",        iptables_xml_main},
       {"xml4",                iptables_xml_main},
#endif

to

#endif
       {"iptables-xml",        iptables_xml_main},
       {"xml",                 iptables_xml_main},

(and maybe add an ip6tables-xml alias as well?)


2011/5/30 Maciej =C5=BBenczykowski <zenczykowski@gmail.com>:
> ACK.
>
> Never used it, didn't realize it was useful for ipv6 as well.
> Perhaps in xtables-multi some changes should be made as well?
> (change xml4, and change the #ifdef ENABLE_IPV4 wrapper).
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
