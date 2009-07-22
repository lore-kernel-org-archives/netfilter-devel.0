From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Only use libdl when shared builds are enabled (was: Only build
 iptables-xml)
Date: Wed, 22 Jul 2009 14:50:24 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907221448370.6634@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>  <4A650A45.9070300@snapgear.com> <1248263655.1567.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Philip Craig <philipc@snapgear.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52691 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZGVMuZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:50:25 -0400
In-Reply-To: <1248263655.1567.9.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-07-22 13:54, Henrik Nordstrom wrote:
>tis 2009-07-21 klockan 10:22 +1000 skrev Philip Craig:
>> Jan Engelhardt wrote:
>> > Hi Philip,
>> > 
>> > 
>> > try this one instead.
>> 
>> Doesn't work:
>
>And you are sure you used --disable-shared when you ran configure?

I know, I hit this too. Needs more thought, disable-shared won't fix it 
atm.
