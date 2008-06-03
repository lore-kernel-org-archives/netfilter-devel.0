From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: [PATCH 3/3] libnetfilter-conntrack byte alignment
Date: Tue, 03 Jun 2008 11:21:23 +0100
Message-ID: <1212488483.29489.42.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56726 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751950AbYFCKVZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:21:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=EF=BB=BFAligns buffers to maximum alignment of architecture to make th=
e cast of
char pointers to struct pointers more portable.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>


diff -ruN libnetfilter_conntrack-0.0.89.orig/src/conntrack/api.c libnet=
filter_conntrack-0.0.89/src/conntrack/api.c
--- libnetfilter_conntrack-0.0.89.orig/src/conntrack/api.c	2008-06-02 1=
9:35:12.000000000 +0100
+++ libnetfilter_conntrack-0.0.89/src/conntrack/api.c	2008-06-02 19:38:=
07.000000000 +0100
@@ -561,7 +561,7 @@
 	       const void *data)
 {
 	size_t size =3D 4096;	/* enough for now */
-	char buffer[4096];
+	char buffer[4096] __attribute__ ((aligned));
 	struct nfnlhdr *req =3D (struct nfnlhdr *) buffer;
=20
 	assert(h !=3D NULL);
diff -ruN libnetfilter_conntrack-0.0.89.orig/src/expect/api.c libnetfil=
ter_conntrack-0.0.89/src/expect/api.c
--- libnetfilter_conntrack-0.0.89.orig/src/expect/api.c	2008-06-02 19:3=
5:12.000000000 +0100
+++ libnetfilter_conntrack-0.0.89/src/expect/api.c	2008-06-02 19:39:59.=
000000000 +0100
@@ -507,7 +507,7 @@
 	        const void *data)
 {
 	size_t size =3D 4096;	/* enough for now */
-	char buffer[4096];
+	char buffer[4096] __attribute__ ((aligned));
 	struct nfnlhdr *req =3D (struct nfnlhdr *) buffer;
=20
 	assert(h !=3D NULL);


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
