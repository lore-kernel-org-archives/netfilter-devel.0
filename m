From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 13:56:08 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1412181353020.1745@nerf08.vanv.qr>
References: <20141218134703.11fc792a@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:40653 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaLRM4K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 07:56:10 -0500
In-Reply-To: <20141218134703.11fc792a@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2014-12-18 13:47, J=C3=B6rg Thalheim wrote:
>+
>+nftables_confdir =3D ${sysconfdir}
>+nftables_conf_DATA =3D nftables.conf

Per systemd and distro directions, upstream-provided files should reall=
y really be located in /usr, not /etc
(this location being reserved for machine- and user-specific tweaks).

That's why something.service is provided in /usr(/lib/systemd/system/) =
rather
rather than /etc/systemd/system, for example.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
