From: Daniel Fiala <danfiala@zoho.com>
Subject: Developing own utils based on libipset
Date: Mon, 23 Sep 2013 14:09:35 +0000 (UTC)
Message-ID: <loom.20130923T160412-833@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37900 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab3IWOkF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:40:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1VO7Ix-0000ch-WA
	for netfilter-devel@vger.kernel.org; Mon, 23 Sep 2013 16:40:04 +0200
Received: from 89-24-204-212.i4g.tmcz.cz ([89.24.204.212])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2013 16:40:03 +0200
Received: from danfiala by 89-24-204-212.i4g.tmcz.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2013 16:40:03 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.
I would need to perform some manipulations with IPSet tables
from my own application written in C. 
It seems that I understand the interface and can successfully use it.
But is it safe and can I rely on the library interface, or can it change
significantly in the near future?

Thanks,
Daniel Fiala

