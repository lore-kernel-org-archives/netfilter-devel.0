From: arif <aftnix@gmail.com>
Subject: Splitting network packets from target modules
Date: Thu, 15 Nov 2012 19:14:44 +0600
Message-ID: <k82ps8$uh2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60490 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767736Ab2KONT4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:19:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1TYzMR-00067D-Ec
	for netfilter-devel@vger.kernel.org; Thu, 15 Nov 2012 14:20:03 +0100
Received: from 103.23.169.3 ([103.23.169.3])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Nov 2012 14:20:03 +0100
Received: from aftnix by 103.23.169.3 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Nov 2012 14:20:03 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to write a target module which will do the following :

1) oldskb will be cached.
2) newskb1,newskb2....newskbn will be allocated and initialized.
3) packet will be dropped using NF_DROP
4) Newskbs will be sent to L4(target will work from PREROUTING hook)

But i'm confused how i'm going to send these new skbs to uplink.
returning NF_ACCEPT will not do the trick i guess.

Is there any existing target module which tries to do send multiple skbs
to uplink?

cheers
arif

