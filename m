From: Sebastian Classen <sebastian.classen@freenet.ag>
Subject: make print-extensions doesn't show libxt_* extensions
Date: Fri, 05 Oct 2007 14:52:10 +0200
Message-ID: <1191588730.4456.14.camel@basti79.freenet-ag.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ULvYkLhsM66luPEpfGhU"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:57667 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbXJEMwN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:52:13 -0400
Received: from [195.4.92.10] (helo=mx0.freenet.de)
	by mout0.freenet.de with esmtpa (Exim 4.68)
	(envelope-from <sebastian.classen@freenet.ag>)
	id 1Idmf5-0007RL-22
	for netfilter-devel@vger.kernel.org; Fri, 05 Oct 2007 14:52:11 +0200
Received: from basti79.freenet-ag.de ([194.97.7.5]:36337)
	by mx0.freenet.de with esmtps (TLSv1:RC4-MD5:128) (port 25) (Exim 4.68 #6)
	id 1Idmf5-0000dq-0K
	for netfilter-devel@vger.kernel.org; Fri, 05 Oct 2007 14:52:11 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--=-ULvYkLhsM66luPEpfGhU
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

In extensions/Makefile the variable PFX_EXT_SLIB_OPTS is not appended to
OPTIONALS, therefor 'make print-extensions' doesn't show any optional
libxt_* extension.

Patch against last iptables snapshot attached.
=20
Greets
  Sebastian.

--=20
Mit freundlichen Gr=FC=DFen / Yours sincerely

Sebastian Cla=DFen
Postmaster
----------------------------------------------------------------------
Telefon: + 49 (0) 211 53087 522
Telefax: + 49 (0) 211 5381573
E-Mail:  sebastian.classen@freenet.ag
Website: www.freenet.de; www.mobilcom.de
----------------------------------------------------------------------
freenet AG
Willst=E4tterstr. 13
40549 D=FCsseldorf
----------------------------------------------------------------------
Vorsitzender des Aufsichtsrates: Prof. Dr. Helmut Thoma
Vorstand: Eckhard Spoerr (Vors.), Axel Krieger, Stephan Esch, Eric Berger
Sitz: B=FCdelsdorf
Amtsgericht Kiel HRB 7306 KI

--=-ULvYkLhsM66luPEpfGhU
Content-Disposition: attachment; filename=iptables-1.3.8-20071004.diff
Content-Type: text/x-patch; name=iptables-1.3.8-20071004.diff; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

--- iptables-1.3.8-20071004/extensions/Makefile.orig	2007-10-05 14:42:17.000000000 +0200
+++ iptables-1.3.8-20071004/extensions/Makefile	2007-10-05 14:41:31.000000000 +0200
@@ -85,6 +85,7 @@ PF_EXT_SLIB+=$(PF_EXT_SLIB_OPTS)
 PF6_EXT_SLIB+=$(PF6_EXT_SLIB_OPTS)
 PFX_EXT_SLIB+=$(PFX_EXT_SLIB_OPTS)
 
+OPTIONALS+=$(patsubst %,XT:%,$(PFX_EXT_SLIB_OPTS))
 OPTIONALS+=$(patsubst %,IPv4:%,$(PF_EXT_SLIB_OPTS))
 OPTIONALS+=$(patsubst %,IPv6:%,$(PF6_EXT_SLIB_OPTS))
 

--=-ULvYkLhsM66luPEpfGhU--

