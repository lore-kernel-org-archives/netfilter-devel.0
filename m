From: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>
Subject: Patch for geoip match agains kernel 2.6.28
Date: Thu, 22 Jan 2009 21:59:19 +0100
Message-ID: <000301c97cd4$4b810f30$e2832d90$%olav@bjerkeset.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bgo1smout1.broadpark.no ([217.13.4.94]:59409 "EHLO
	bgo1smout1.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZAVV7i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 16:59:38 -0500
Received: from bgo1sminn1.broadpark.no ([217.13.4.93])
 by bgo1smout1.broadpark.no
 (Sun Java(tm) System Messaging Server 6.3-3.01 (built Jul 12 2007; 32bit))
 with ESMTP id <0KDW00D2J4YJCFD0@bgo1smout1.broadpark.no> for
 netfilter-devel@vger.kernel.org; Thu, 22 Jan 2009 21:59:07 +0100 (CET)
Received: from highbury.bjerkeset.com ([84.48.117.63])
 by bgo1sminn1.broadpark.no
 (Sun Java(tm) System Messaging Server 6.3-3.01 (built Jul 12 2007; 32bit))
 with ESMTP id <0KDW000UN4YIM3H0@bgo1sminn1.broadpark.no> for
 netfilter-devel@vger.kernel.org; Thu, 22 Jan 2009 21:59:07 +0100 (CET)
Received: from anfield
 (anfield.bjerkeset.com [IPv6:2001:5c0:1101:e500:213:d3ff:fea1:41a9])
	by highbury.bjerkeset.com (8.14.2/8.14.2) with ESMTP id n0MKx6hn016407	for
 <netfilter-devel@vger.kernel.org>; Thu, 22 Jan 2009 21:59:06 +0100
Content-language: no
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Changes in "struct xt_match" from kernel 2.6.27 to 2.6.28 made the latest
version og Geoip match (Feb 11th 2008) from kernel version 2.6.28 on. I have
developed a patch that will make Geoip match work with 2.6.28.

The patch can be downloaded from the following URL:
http://bjerkeset.com/patches/geoip-match-2.6.28.patch.gz

The patch is against
http://people.netfilter.org/acidfu/patchlets/geoip.tar.gz as of Feb 11th
2008.

Regards,
Svein Olav Bjerkeset

