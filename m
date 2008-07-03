From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH,RFC] Route match
Date: Thu, 3 Jul 2008 15:13:46 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807031511310.23294@fbirervta.pbzchgretzou.qr>
References: <20080703003942.GA2012@linuxace.com> <alpine.LNX.1.10.0807030913510.20393@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807031140480.1816@blackhole.kfki.hu> <alpine.LNX.1.10.0807031317090.23294@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39930 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbYGCNNs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:13:48 -0400
In-Reply-To: <Pine.LNX.4.64.0807031425530.1816@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-03 14:39, Jozsef Kadlecsik wrote:
>
>One can find a lot of smaller and bigger missing pieces, like a new table, 
>new hook, if we'd associate a 'routing table' to a 'chain in the iptables 
>route table', then we'd need a default policy support (i.e. default route) 
>for the user defined chains too, etc.

User-defined chains always have an implicit policy of 'RETURN',
and I would not turn a knob on that property anytime.
The default policy for the main chain is of course 'UNREACHABLE'.
