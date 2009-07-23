From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Only use libdl when shared builds are enabled
Date: Thu, 23 Jul 2009 17:50:57 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907231749480.26578@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>  <4A650A45.9070300@snapgear.com> <1248263655.1567.9.camel@localhost.localdomain> <alpine.LSU.2.00.0907221448370.6634@fbirervta.pbzchgretzou.qr> <4A67A9C8.4040103@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <henrik@henriknordstrom.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39693 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZGWPu5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:50:57 -0400
In-Reply-To: <4A67A9C8.4040103@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-07-23 02:07, Philip Craig wrote:
>Jan Engelhardt wrote:
>> I know, I hit this too. Needs more thought, disable-shared won't fix it 
>> atm.
>
>Is there any reason to support both --enable-shared and --enable-static
>at the same time?

Well yes. I fixed it now, please try

	git://dev.medozas.de/iptables master

for new instructions see `git log -p INSTALL`.
