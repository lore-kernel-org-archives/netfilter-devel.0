From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2] add systemd service file
Date: Fri, 20 Mar 2015 12:06:47 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1503201203430.21239@nerf40.vanv.qr>
References: <20150320105304.043069e6@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:55416 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbbCTLGt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2015 07:06:49 -0400
In-Reply-To: <20150320105304.043069e6@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-03-20 10:53, J=C3=B6rg Thalheim wrote:
>=20
>+AC_PATH_TOOL(PKGCONFIG, pkg-config)
>+

Sure you don't want to actually use PKG_PROG_PKG_CONFIG?

>@@ -0,0 +1,17 @@
>+[Unit]
>+Description=3DNetfilter Tables

That is rather non-descript. It should perhaps say something
involving "network packet filter".

>+[Install]
>+WantedBy=3Dmulti-user.target

This ought to be basic.target.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
