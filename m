From: Ben Gardiner <BenGardiner@nanometrics.ca>
Subject: [PATCH] remove dynamic libiptc.so from iptables-static
Date: Wed, 06 May 2009 15:15:08 +0000
Message-ID: <4A01A97C.6040305@nanometrics.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080804040601080806030907"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.nanometrics.ca ([206.191.47.130]:56905 "EHLO
	mail.nanometrics.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZEFPWf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 11:22:35 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.nanometrics.ca (Postfix) with ESMTP id B92B92875824
	for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2009 11:15:15 -0400 (EDT)
Received: from mail.nanometrics.ca ([127.0.0.1])
	by localhost (mail.nanometrics.ca [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4KahwvMQ3N8w for <netfilter-devel@vger.kernel.org>;
	Wed,  6 May 2009 11:15:08 -0400 (EDT)
Received: from [10.11.2.17] (beng-pc.nanometrics.ca [10.11.2.17])
	by mail.nanometrics.ca (Postfix) with ESMTP id AE9E92875722
	for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2009 11:15:08 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080804040601080806030907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I was building iptables-static from 1.4.3.2 and I noticed that ldd 
reported libiptc.so was a dependency; I was using gcc 4.0.1 for ppc 
cross compile -- but I don't think the toolchain is the cause. I was 
able to get iptables-static to depend only on libm and libc with the 
following patch (made against the 1.4.3.2 dist, but applies clean to svn 
trunk). I hope you will consider it for inclusion in the next release.

Thanks,
Ben Gardiner

diff --git a/Makefile.am b/Makefile.am
index fd99098..80ee250 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,7 +15,12 @@ lib_LTLIBRARIES =
 
 # libiptc
 lib_LTLIBRARIES           += libiptc/libiptc.la
-libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
+if ENABLE_IPV4
+libiptc_libiptc_la_SOURCES = libiptc/libip4tc.c
+endif
+if ENABLE_IPV6
+libiptc_libiptc_la_SOURCES = libiptc/libip6tc.c
+endif
 libiptc_libiptc_la_LDFLAGS = -version-info 0:0:0
 
 lib_LTLIBRARIES      += libxtables.la
@@ -44,10 +49,10 @@ iptables_save_SOURCES     = iptables-save.c iptables.c
 iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
 iptables_save_LDADD       = ${iptables_LDADD}
 
-# iptables-multi, semi-static
-iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c
+# iptables-static
+iptables_static_SOURCES   = ${iptables_multi_SOURCES} xtables.c 
${libiptc_libiptc_la_SOURCES}
 iptables_static_CFLAGS    = ${iptables_multi_CFLAGS} -DNO_SHARED_LIBS=1
-iptables_static_LDADD     = libiptc/libiptc.la extensions/libext4.a -lm
+iptables_static_LDADD     = extensions/libext4.a -lm
 
 iptables_xml_SOURCES      = iptables-xml.c

--------------080804040601080806030907
Content-Type: text/x-vcard; charset=utf-8;
 name="BenGardiner.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="BenGardiner.vcf"

begin:vcard
fn:Ben Gardiner
n:Gardiner;Ben
org:Nanometrics Seismological Instruments;Software R&D
adr:;;250 Herzberg Rd.;Kanata;ON;K2K 2A1;Canada
email;internet:bengardiner@nanometrics.ca
title:M.Sc. Eng.
tel;work:613 592 6776 x239
tel;fax:613 592 5929
x-mozilla-html:FALSE
url:www.nanometrics.ca
version:2.1
end:vcard


--------------080804040601080806030907--
