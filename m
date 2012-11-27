From: Sebastian Zander <sebastian.zander@gmx.de>
Subject: Conntrack helper question
Date: Tue, 27 Nov 2012 12:03:31 +1100
Message-ID: <50B41163.9020102@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sebastian Zander <sebastian.zander@gmx.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49156 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932976Ab2K0BDr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:03:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi netfilter devs,

In current Netfilter is there still a way for a conntrack helper to 
listen to all TCP traffic _independent_ of ports to look for primary 
connections (other than registering with 65535 tuples)? Not that I 
advocate this, I just have some old piece of code that apparently did 
that in ancient 2.6 kernels (ports set to zero in the tuple).

Please cc me, since I'm not on the list. Many thanks in advance!

Cheers,

Sebastian
