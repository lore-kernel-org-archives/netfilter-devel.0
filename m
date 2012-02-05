From: Ian Pilcher <arequipeno@gmail.com>
Subject: Doc on writing conntrack module?
Date: Sun, 05 Feb 2012 10:55:14 -0600
Message-ID: <jgmc9i$mid$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32812 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab2BERAE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:00:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Ru5Rb-0002DU-D6
	for netfilter-devel@vger.kernel.org; Sun, 05 Feb 2012 18:00:03 +0100
Received: from pool-71-252-228-112.dllstx.fios.verizon.net ([71.252.228.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Feb 2012 18:00:03 +0100
Received: from arequipeno by pool-71-252-228-112.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Feb 2012 18:00:03 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I would like to write a conntrack module for the Simple Service
Discovery Protocol (SSDP):

    http://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol

This certainly seems like it should be reasonably straightforward, but
I'm having trouble relating the documentation in the Hacking HOWTO to
what I see in the actual kernel (in nf_conntrack_snmp.c, for example).
Hardly surprising, given the age of the HOWTO.

Is there any more recent documentation?

If not (i.e. there's only the kernel source), pointers to the particular
headers, functions, and macros on which I should be focusing would be
much appreciated.

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
"If you're going to shift my paradigm ... at least buy me dinner first."
========================================================================

