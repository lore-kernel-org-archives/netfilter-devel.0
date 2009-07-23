From: Philip Craig <philipc@snapgear.com>
Subject: Re: Only use libdl when shared builds are enabled
Date: Thu, 23 Jul 2009 10:07:36 +1000
Message-ID: <4A67A9C8.4040103@snapgear.com>
References: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>  <4A650A45.9070300@snapgear.com> <1248263655.1567.9.camel@localhost.localdomain> <alpine.LSU.2.00.0907221448370.6634@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <henrik@henriknordstrom.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:43185 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751314AbZGWAHi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2009 20:07:38 -0400
In-Reply-To: <alpine.LSU.2.00.0907221448370.6634@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I know, I hit this too. Needs more thought, disable-shared won't fix it 
> atm.

Is there any reason to support both --enable-shared and --enable-static
at the same time?

If we don't support that then the fix is fairly straightforward.
