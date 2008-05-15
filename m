From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 13:18:14 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
References: <200805151421.23862.anton.vazir@gmail.com> <200805151535.31933.anton.vazir@gmail.com> <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr> <200805151557.28368.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYEOLSP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 07:18:15 -0400
In-Reply-To: <200805151557.28368.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2008-05-15 12:57, Anton wrote:

>Definitelly what my test shows - while rule-inserts - if you 
>try to insert 10000 rules - after a several hundreds - it 
>will be inserting like a 1 rule in 1 second and slowness 
>will progress :)

Your insertion slowness is probably due to incorrect use of iptables.

