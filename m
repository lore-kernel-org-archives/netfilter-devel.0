From: Victor Stinner <victor.stinner@inl.fr>
Subject: libnetfilter_conntrack broken on PPC
Date: Fri, 16 Nov 2007 11:39:19 +0100
Message-ID: <200711161139.19580.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_XNXPHXxzO2Bxllx"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp6-g19.free.fr ([212.27.42.36]:51346 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbXKPKjW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:39:22 -0500
Received: from smtp6-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 7BEF05FE2F
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Nov 2007 11:39:20 +0100 (CET)
Received: from marge.local (neu67-4-88-160-66-91.fbx.proxad.net [88.160.66.91])
	by smtp6-g19.free.fr (Postfix) with ESMTP id 283EC5FE84
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Nov 2007 11:39:20 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--Boundary-00=_XNXPHXxzO2Bxllx
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Libnetfilter_conntrack doesn't work on PPC because a small bug in "getters" 
(8, 16, 32 bits). The problem only occurs on big endian architecture and is 
already fixed in subversion. My patch only fix big endian bug, and is very 
small ;-)

I sent the patch to Pablo Neira Ayuso the first october, but he looks very 
busy. Can someone else release a new version of libnetfilter_conntrack? If 
nobody cares, can I get the status of new libnetfilter_conntrack maintainer?

Victor Stinner
http://www.inl.fr/

--Boundary-00=_XNXPHXxzO2Bxllx
Content-Type: text/x-diff;
  charset="us-ascii";
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
 

--Boundary-00=_XNXPHXxzO2Bxllx--
