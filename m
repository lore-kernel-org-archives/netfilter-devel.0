From: Roger Sala <rsala@ssci.com>
Subject: nfnetlink_queue interfering with ioctl calls
Date: Thu, 9 Sep 2010 11:16:26 -0400
Message-ID: <4C88FA4A.8040201@ssci.com>
Reply-To: Roger Sala <rsala@ssci.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 173-14-162-93-NewEngland.hfc.comcastbusiness.net ([173.14.162.93]:29574
	"EHLO getafix.ssci.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751698Ab0IIPsJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:48:09 -0400
Received: from getafix.ssci.com (localhost [127.0.0.1])
	by getafix.ssci.com (8.13.8/8.13.8) with ESMTP id o89FGRIL003626
	for <netfilter-devel@vger.kernel.org>; Thu, 9 Sep 2010 11:16:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I tried posting this to the netfilter users list but I didn't get any 
response.  Maybe its a question for the devs?

I have code that makes the SIOCGARP ioctl call that works correctly 
(i.e. it either returns successfully when it finds a match in the arp 
cache or it returns -1).  However when I integrate that same code with 
nfnetlink_queue code it no longer works as expected (i.e. it returns 
successfully (0) when the address is not found in the arp cache and it 
doesn't copy anything into the struct arpreq).  I searched the archives 
and didn't see anything about this.  Does anyone have any idea what 
could be causing this?
