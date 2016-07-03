From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: libxtables backward compatibility
Date: Sun, 3 Jul 2016 16:00:42 -0400
Message-ID: <20160703160042.76f76433@playground>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.wpi.edu ([130.215.36.91]:53035 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbcGCUVA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 16:21:00 -0400
Received: from MAIL1.WPI.EDU (MAIL1.WPI.EDU [130.215.36.91])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id u63K0jNa002879
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 16:00:45 -0400
Received: from MX1.WPI.EDU (mx1.wpi.edu [130.215.36.141])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id u63K0jQr002876
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 16:00:45 -0400
Received: from ALUM.WPI.EDU (alum.wpi.edu [130.215.36.126])
	by MX1.WPI.EDU (8.14.4/8.14.4) with ESMTP id u63K0iVO002215
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 16:00:45 -0400
	(envelope-from neal.p.murphy@alum.wpi.edu)
Received: from playground (c-73-251-108-62.hsd1.va.comcast.net [73.251.108.62])
	(authenticated authen=neal.p.murphy)
	by ALUM.WPI.EDU (8.15.1/8.15.1) with ESMTPSA id u63K0hMJ007276
	(version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 16:00:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've search hither and yon and have found no (obvious) answers.

Are newer versions of libxtables.so backward-compatible with older versions?

Specifically, should programs linked to--and expecting to use--libxtables.so.7 (iptables v1.4.14) work with versions libxtables.so.10 (v1.4.21) and libxtables.so.11 (v1.6)? I suspect yes, since I haven't seen problems symlinking .10 to .7. But a definitive answer would be nice to have.

If they aren't compatible, I'll plan on including .7 and .10 binaries in the update packet.

(I know about nftables and look forward to deploying its flexibility, but we're still on linux 3.4; I'm working on updating to 3.14. Our next release will use linux 4.4 (or newer) and nftables. But that is a major change; we have a lot of rule generators in several syntaxes that will need to be modernized. The user interface will also need to be reworked.)

Thanks,
Neal
