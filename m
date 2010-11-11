From: Jan Kasprzak <kas@fi.muni.cz>
Subject: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 16:00:55 +0100
Message-ID: <20101111150055.GI15421@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:44488 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0KKPWT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:22:19 -0500
Received: from anxur.fi.muni.cz (anxur.fi.muni.cz [147.251.48.3])
	by minas.ics.muni.cz (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id oABF0tux005630
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Nov 2010 16:00:56 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

	Hello,

I have a iptables-based firewall with ~1200 IPv4 and ~950 IPv6 rules.
When I want to reload its configuration, I often get "Resource temporarily
unavailable" error from iptables.

I have a HA setup with two servers, and the error more often happens on
a server with four cores and 2 GB of RAM than on a server with two cores
and 4 GB of RAM.

I have added a band-aid fix to my startup script - sleeping for one second
and trying again when the error code from iptables is 4, and it apparently
helps. But the error messages from the startup script are still a bit ugly.
What else can I do in order to fix the problem?

	Thanks,

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
