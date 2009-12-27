From: Holger Freyther <zecke@selfish.org>
Subject: [PATCH] doxygen.cfg.in: Make the file Work with doxygen 1.6.1
Date: Sun, 27 Dec 2009 06:53:08 +0100
Message-ID: <200912270653.09352.zecke@selfish.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FZvNLq4XqPVn4oi"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gandharva.secretlabs.de ([78.46.147.237]:55984 "EHLO
	gandharva.secretlabs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZL0FxU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Dec 2009 00:53:20 -0500
Received: from tamarin.localnet (123-192-180-176.dynamic.kbronet.com.tw [123.192.180.176])
	by gandharva.secretlabs.de (Postfix) with ESMTPSA id F2A331B10C04
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Dec 2009 05:49:52 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_FZvNLq4XqPVn4oi
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

this is slighly more useful than the previous attempt. doxygen version 1.6.1 
(as of Ubuntu Karmic) will refuse to generate the documentation as the 
referenced header.html does not exist. This file was never in the repository 
and emptying that option makes it work for 1.6 and keeps working for 1.5.6 
(this version is included in Debian Lenny).


regards
	holger

--Boundary-00=_FZvNLq4XqPVn4oi
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-doxygen.cfg.in-Make-the-file-Work-with-doxygen-1.6.1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-doxygen.cfg.in-Make-the-file-Work-with-doxygen-1.6.1.patch"

=46rom 5876d2d3790c92ab76927947a7d0f78db48481d9 Mon Sep 17 00:00:00 2001
=46rom: Holger Hans Peter Freyther <zecke@selfish.org>
Date: Sat, 26 Dec 2009 17:29:11 +0100
Subject: [PATCH] doxygen.cfg.in: Make the file Work with doxygen 1.6.1

* DETAILS_AT_TOP is deprecated and newer versions of
  doxygens are warning about this. Remove this option.
* Empty HTML_HEADER as newer versions of doxygen check
  if the file exists and fail if it doesn't. Looking at
  the history of this project the file never existed.
* This continues to work with doxygen 1.5.6.

Signed-off-by: Holger Hans Peter Freyther <zecke@selfish.org>
=2D--
 doxygen.cfg.in |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index bb39a6d..37bfa7c 100644
=2D-- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -16,7 +16,6 @@ SHORT_NAMES            =3D NO
 JAVADOC_AUTOBRIEF      =3D NO
 QT_AUTOBRIEF           =3D NO
 MULTILINE_CPP_IS_BRIEF =3D NO
=2DDETAILS_AT_TOP         =3D NO
 INHERIT_DOCS           =3D YES
 SEPARATE_MEMBER_PAGES  =3D NO
 TAB_SIZE               =3D 8
@@ -95,7 +94,7 @@ IGNORE_PREFIX          =3D
 GENERATE_HTML          =3D YES
 HTML_OUTPUT            =3D html
 HTML_FILE_EXTENSION    =3D .html
=2DHTML_HEADER            =3D "header.html"
+HTML_HEADER            =3D=20
 HTML_STYLESHEET        =3D=20
 HTML_ALIGN_MEMBERS     =3D YES
 GENERATE_HTMLHELP      =3D NO
=2D-=20
1.6.3.3


--Boundary-00=_FZvNLq4XqPVn4oi--
