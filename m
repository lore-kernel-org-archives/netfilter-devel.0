From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Howto: filtering on a per process/program basis
Date: Fri, 16 Sep 2011 12:49:11 +0200
Message-ID: <j4v9j8$isk$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35407 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1IPKzM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:55:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1R4W4Z-00034j-Gs
	for netfilter-devel@vger.kernel.org; Fri, 16 Sep 2011 12:55:07 +0200
Received: from p4fdf574f.dip.t-dialin.net ([79.223.87.79])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Sep 2011 12:55:07 +0200
Received: from for-gmane by p4fdf574f.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Sep 2011 12:55:07 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I need filtering on a per process (ie. program name) basis.
Is this already possible in iptables/netfilter/xtables etc., or in an addon?

Practically:
   Normal filtering rules based on srcaddr, dstaddr, proto, srcport, dstport etc,
   Allow only specified applications sending of packets,
   Allow only specified applications reception of packets,
   Optionally log anything else,
   Discard anything else.

When I write and install a netfilter module then how would
I go to get the process name from within the kernel module?

