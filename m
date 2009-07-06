From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter/iptables hashlimit query
Date: Mon, 6 Jul 2009 10:55:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907061054540.30256@fbirervta.pbzchgretzou.qr>
References: <1246861636.19710.100.camel@ripper.synapse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ritesh Majumdar <r.majumdar@globallogic.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49921 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZGFIzH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:55:07 -0400
In-Reply-To: <1246861636.19710.100.camel@ripper.synapse.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-07-06 08:27, Ritesh Majumdar wrote:

>Hello List,
>
>I using kernel 2.6.27 and iptables-1.4.1. I want to use the iptables
>hashlimit feature. while looking through haslimit mode options I found
>that it has srcip,srcport,dstip,dstport only. 
>
>I was wondering if this has any options like srcnet and dstnet also. or
>if not available , how can we include this fetaure ?

See --hashlimit-{src,dst}mask.
