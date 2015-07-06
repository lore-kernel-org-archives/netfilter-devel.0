From: Jan Engelhardt <jengelh@inai.de>
Subject: RE: Kernel 4.1.0 broke the TARPIT & DELUGE targets in
 xtables-addons-2.6
Date: Mon, 6 Jul 2015 05:45:16 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507060544560.14794@nerf40.vanv.qr>
References: <6ba05a9b-e2ef-4c32-ab22-5e9e8440c91a@zeracles.net.ru> <94a5fd8b-f435-4d6b-a810-ee59781ad58d@zeracles.net.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: 'Florian Westphal' <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Alexander Petrenas <zeracles@zeracles.net.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:38234 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbbGFDpS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2015 23:45:18 -0400
In-Reply-To: <94a5fd8b-f435-4d6b-a810-ee59781ad58d@zeracles.net.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2015-06-23 13:17, Alexander Petrenas wrote:

>Well, unfortunately, you should disregard previous message in part of submitting it to xtables-addons ASAP. 
>
>While modules compiled without errors, actually applying iptables TARPIT rule results in a connection loss, the nature of which I unfortunately cannot describe at the moment (was trying to apply the update to a remote server without KVM). It kind of looks like a kernel panic though - no messages are written to any logs after adding the TARPIT rule - the server just goes dead.
>
>I guess more research is needed on the matter, I'll try to run some tests on a local machine & post the results.

Yeah you need to also change dst_output to dst_output_sk.

Don't just ignore compiler warnings!

