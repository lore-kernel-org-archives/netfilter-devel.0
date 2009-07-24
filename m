From: Philip Craig <philipc@snapgear.com>
Subject: Re: Only use libdl when shared builds are enabled
Date: Fri, 24 Jul 2009 19:02:10 +1000
Message-ID: <4A697892.8040508@snapgear.com>
References: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>  <4A650A45.9070300@snapgear.com> <1248263655.1567.9.camel@localhost.localdomain> <alpine.LSU.2.00.0907221448370.6634@fbirervta.pbzchgretzou.qr> <4A67A9C8.4040103@snapgear.com> <alpine.LSU.2.00.0907231749480.26578@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <henrik@henriknordstrom.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:57379 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbZGXJCN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:02:13 -0400
In-Reply-To: <alpine.LSU.2.00.0907231749480.26578@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-07-23 02:07, Philip Craig wrote:
>> Is there any reason to support both --enable-shared and --enable-static
>> at the same time?
> 
> Well yes. I fixed it now, please try
> 
> 	git://dev.medozas.de/iptables master
> 
> for new instructions see `git log -p INSTALL`.

The changes look good, and I understand what you meant by overloaded
meaning for enable-static now.
