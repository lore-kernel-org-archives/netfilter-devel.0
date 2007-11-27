From: Patrick McHardy <kaber@trash.net>
Subject: iptables release
Date: Tue, 27 Nov 2007 17:52:55 +0100
Message-ID: <474C4B67.3000200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35679 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbXK0QxG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:53:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I have a large number of pending patches for iptables for new
matches and targets. I'm not going apply patches for new things
unless they are at least in a -rc kernel, so we have a chance to
fix mistakes. So my question is whether we're ready to release
the current iptables -rc anytime soon (before/when 2.6.24 is
released) or whether we're more likely going to need until 2.6.25,
in which case I would apply them now.

Any opinions?
