From: David Miller <davem@davemloft.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 02:12:54 -0800 (PST)
Message-ID: <20071116.021254.114985389.davem@davemloft.net>
References: <473CDF12.9080206@trash.net>
	<Pine.LNX.4.64.0711160139480.3340@fbirervta.pbzchgretzou.qr>
	<473D6C99.1010306@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55593
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756131AbXKPKMz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:12:55 -0500
In-Reply-To: <473D6C99.1010306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 16 Nov 2007 11:10:33 +0100

> Jan Engelhardt wrote:
> > Yeah, I'd agree that on CONFIG_NETFILTER_ADVANCED=no, all the fluffy
> > modules should be selected. It is largely an allmodconfig inside
> > the nf menuconfig tree.
> 
> Mhh I'm not sure if that should really select all modules, I was more
> thinking of NETFILTER_ADVANCED=n should select the basic modules that
> are needed to run let say a normal distribution firewall script, and
> CONFIG_NETFILTER_ADVANCED=y would give you more choice over the modules.

I think this is what Jan meant to say, he just forgot a "not"
somewhere :-)
