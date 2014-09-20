From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: Bug: ipset-6.22 broken with dynamic modules
Date: Sat, 20 Sep 2014 14:20:27 +0000 (UTC)
Message-ID: <loom.20140920T161855-163@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54727 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaITOUk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:20:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1XVLWg-00083c-TL
	for netfilter-devel@vger.kernel.org; Sat, 20 Sep 2014 16:20:38 +0200
Received: from d118003.upc-d.chello.nl ([213.46.118.3])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Sep 2014 16:20:38 +0200
Received: from sfzhi by d118003.upc-d.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Sep 2014 16:20:38 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have just tried building ipset-6.22 and encountered this issue. When
configured with --enable-settype-modules --with-settype-modules-list=all the
build succeeds, but what it produces is unusable, because the modules
require several symbols that are not exported from libipset.so. As far as I
can tell, those missing symbols are the five functions introduced with the
commit c1dd8442aac6cadb29110f763f23cafc63135a79 (libipset: Add userspace
code for the skbinfo extension support).

Regards,
Sergei.

