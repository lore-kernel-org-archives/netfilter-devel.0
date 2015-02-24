From: Sourabh Rudrawar <sourabh.rudrawar@gmail.com>
Subject: =?utf-8?b?bGlibmV0ZmlsdGVyX2Nvbm50cmFjaw==?= API is not working
Date: Tue, 24 Feb 2015 11:02:14 +0000 (UTC)
Message-ID: <loom.20150224T113432-322@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56118 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbBXLCe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 06:02:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1YQDG3-0006mg-1E
	for netfilter-devel@vger.kernel.org; Tue, 24 Feb 2015 12:02:31 +0100
Received: from 115.113.153.34.static-pune.vsnl.net.in ([115.113.153.34.static-pune.vsnl.net.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2015 12:02:31 +0100
Received: from sourabh.rudrawar by 115.113.153.34.static-pune.vsnl.net.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2015 12:02:31 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, 
 
 I am using ubuntu-12.04-desktop version in Virtual Box.I am testing
utils/conntrack_events.c using libnetfilter_conntrack API. But I get stuck on 
    TEST: waiting for 10 events...
And no event get caught even if I keep this running forever.



Thanks
Sourabh

