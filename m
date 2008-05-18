From: Anton <anton.vazir@gmail.com>
Subject: TPROXY 4.1 patch?
Date: Sun, 18 May 2008 19:50:24 +0500
Message-ID: <200805181950.24777.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:42345 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156AbYEROuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 May 2008 10:50:37 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi !

Just hoping if anyone may have a working TPROXY 4.1 patch 
against any of 2.6.24 or 2.6.25 kernel versions? 

Patches provided by BALABIT on their site does not apply 
cleanly on the mainstream kernels (and even after manual 
patching of rejects kernel does not compile than, some 
structure inconsistancies) , I suppose the patches have 
been taken out of some of the kernel developments branches, 
but I've did not found how to download any of this 
branches. -git gives only stable tags, but there is just a 
numeric tags...

There is some patches in the

http://people.netfilter.org/hidden/tproxy/

but they does not apply cleanly to a stable kernels either.

If someone have a patch or any advice, I'd be just 
gratefull, TPROXY+SQUID is a great stuff btw.

Kind regards,
Anton.
