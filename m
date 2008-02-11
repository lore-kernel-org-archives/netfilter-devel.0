From: "Robert Bruce" <rob@thirddimensiondesign.co.uk>
Subject: iptables + geoip
Date: Mon, 11 Feb 2008 08:30:56 -0000 (GMT)
Message-ID: <13602.193.36.79.206.1202718656.squirrel@webmail.tdd.org.uk>
Reply-To: rob@thirddimensiondesign.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tdd.org.uk ([92.48.67.77]:49532 "EHLO mail.tdd.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYBKImB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 03:42:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I tried to send this to the developers of geoip, but the email got
returned to me. I can't put this on bugzilla as it is down at the
moment...

Original Email:

Hi Guys

I've just tried to install geoip with iptables 1.4.0, everything is fine
until I try to add a rule which uses the geoip module and I get a
Segmentation fault. So I did some digging, compiled with -g for gdb and
found that the problem is on line 229 as match is passed in with an
address to 0x0.

I dunno how to fix that though..


