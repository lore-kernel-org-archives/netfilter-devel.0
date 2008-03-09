From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] Release conntrack-tools 0.9.6
Date: Sun, 09 Mar 2008 21:12:39 +0100
Message-ID: <47D444B7.40505@netfilter.org>
References: <47D28F29.6080707@netfilter.org> <003b01c881ae$ce989d60$6bc9d820$@com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000400010308010706060705"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Gilad Benjamini <gilad@vbrix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59495 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753024AbYCIUMx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:12:53 -0400
In-Reply-To: <003b01c881ae$ce989d60$6bc9d820$@com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000400010308010706060705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Gilad Benjamini wrote:
> Hi,
> The tarball includes ".svn" directories under the doc subdirectory.
> May I assume this is a mistake ?

Indeed. I forgot to update the dist-hook when I renamed examples/ to
doc/. I just committed the patch attached to SVN.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000400010308010706060705
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: Makefile.am
===================================================================
--- Makefile.am	(revisión: 7395)
+++ Makefile.am	(copia de trabajo)
@@ -17,4 +17,4 @@
 
 dist-hook:
 	rm -rf `find $(distdir)/debian -name .svn`
-	rm -rf `find $(distdir)/examples -name .svn`
+	rm -rf `find $(distdir)/doc -name .svn`

--------------000400010308010706060705--
