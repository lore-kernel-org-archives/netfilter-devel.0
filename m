From: Victor Stinner <victor.stinner@inl.fr>
Subject: libnetfilter_conntrack and PPC64
Date: Fri, 19 Oct 2007 11:13:59 +0200
Message-ID: <200710191113.59898.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XVHGHahB02gESGV"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp6-g19.free.fr ([212.27.42.36]:33006 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965615AbXJSJOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:14:10 -0400
Received: from smtp6-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 5BCB05FE41
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Oct 2007 11:14:09 +0200 (CEST)
Received: from marge.local (neu67-4-88-160-66-91.fbx.proxad.net [88.160.66.91])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 416B05FE6E
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Oct 2007 11:14:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_XVHGHahB02gESGV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

We found a problem with libnetfilter_conntrack on PPC64 computer (64-bit, big 
endian). The last public version (0.81) has three bogus functions :
 * nfct_get_attr_u8
 * nfct_get_attr_u16
 * nfct_get_attr_u32

We also saw that the bug is already fixed in src/conntrack/api.c file of 
subversion. See attached patch that fix the bug. The patch is quite easy to 
understand.

Can someone release a new version of libnetfilter_conntrack just with the 
patch? I already asked Pablo but he's very busy.

Victor Stinner
http://www.inl.fr/

--Boundary-00=_XVHGHahB02gESGV
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="api.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="api.patch"

--- libnetfilter_conntrack-0.0.81/src/conntrack/api.c	2007-06-25 20:40:03.000000000 +0200
+++ libnetfilter_conntrack-trunk/src/conntrack/api.c	2007-09-02 12:02:28.000000000 +0200
@@ -304,7 +304,7 @@
 u_int8_t nfct_get_attr_u8(const struct nf_conntrack *ct,
 			  const enum nf_conntrack_attr type)
 {
-	const int *ret = nfct_get_attr(ct, type);
+	const u_int8_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -320,7 +320,7 @@
 u_int16_t nfct_get_attr_u16(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const int *ret = nfct_get_attr(ct, type);
+	const u_int16_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 
@@ -336,7 +336,7 @@
 u_int32_t nfct_get_attr_u32(const struct nf_conntrack *ct,
 			    const enum nf_conntrack_attr type)
 {
-	const int *ret = nfct_get_attr(ct, type);
+	const u_int32_t *ret = nfct_get_attr(ct, type);
 	return ret == NULL ? 0 : *ret;
 }
 

--Boundary-00=_XVHGHahB02gESGV--
