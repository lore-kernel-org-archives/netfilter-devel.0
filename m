From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: Only use libdl when shared builds are enabled (was: Only build
 iptables-xml)
Date: Wed, 22 Jul 2009 13:54:15 +0200
Message-ID: <1248263655.1567.9.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0907201108470.27235@fbirervta.pbzchgretzou.qr>
	 <4A650A45.9070300@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:36061 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbZGVMKt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2009 08:10:49 -0400
In-Reply-To: <4A650A45.9070300@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tis 2009-07-21 klockan 10:22 +1000 skrev Philip Craig:
> Jan Engelhardt wrote:
> > Hi Philip,
> > 
> > 
> > try this one instead.
> 
> Doesn't work:

And you are sure you used --disable-shared when you ran configure?

Regards
Henrik

