From: Alexander Petrenas <zeracles@zeracles.net.ru>
Subject: RE: Kernel 4.1.0 broke the TARPIT & DELUGE targets in
 xtables-addons-2.6
Date: Tue, 23 Jun 2015 14:17:09 +0300
Message-ID: <94a5fd8b-f435-4d6b-a810-ee59781ad58d@zeracles.net.ru>
References: <6ba05a9b-e2ef-4c32-ab22-5e9e8440c91a@zeracles.net.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: netfilter-devel@vger.kernel.org
To: 'Florian Westphal' <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zeracles.net.ru ([178.252.70.14]:54326 "EHLO zeracles.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbbFWLR1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2015 07:17:27 -0400
In-Reply-To: <6ba05a9b-e2ef-4c32-ab22-5e9e8440c91a@zeracles.net.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Well, unfortunately, you should disregard previous message in part of submitting it to xtables-addons ASAP. 

While modules compiled without errors, actually applying iptables TARPIT rule results in a connection loss, the nature of which I unfortunately cannot describe at the moment (was trying to apply the update to a remote server without KVM). It kind of looks like a kernel panic though - no messages are written to any logs after adding the TARPIT rule - the server just goes dead.

I guess more research is needed on the matter, I'll try to run some tests on a local machine & post the results.

Yours, Alexander Petrenas.

