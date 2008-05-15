From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 14:32:35 +0200
Message-ID: <1210854755.32691.14.camel@henriknordstrom.net>
References: <200805151421.23862.anton.vazir@gmail.com>
	 <200805151535.31933.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
	 <200805151557.28368.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:35163 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYEOMcn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 08:32:43 -0400
In-Reply-To: <200805151557.28368.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On tor, 2008-05-15 at 15:57 +0500, Anton wrote:
> Definitelly what my test shows - while rule-inserts - if you 
> try to insert 10000 rules - after a several hundreds - it 
> will be inserting like a 1 rule in 1 second and slowness 
> will progress :)

If you need to change add many rules then iptables-restore is the tool
to use. Batches the updates in a single transaction, instead of one
transaction per rule...

Regards
Henrik

