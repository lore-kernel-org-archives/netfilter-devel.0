From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: next iptables release
Date: Fri, 20 Mar 2009 14:24:35 +0100
Message-ID: <49C39913.80000@netfilter.org>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net> <alpine.LSU.2.00.0903191444090.27642@fbirervta.pbzchgretzou.qr> <49C24EC7.3020402@trash.net> <alpine.LSU.2.00.0903191456190.27642@fbirervta.pbzchgretzou.qr> <49C251DD.3020309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49087 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752560AbZCTNYq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:24:46 -0400
In-Reply-To: <49C251DD.3020309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> I do to, but I don't see why we should risk it. Its just as well possible
> that someone testing it thinks of a great feature that would perfectly fit
> in, but needs ABI changes. The -rc phase is for testing and also fixing
> and changing things, releasing userspace before the kernel part is set in
> stone is unnecessarily reducing the short amount of time we have for this.

Indeed. I'll apply the patch once iptables is released. Let me know if I
can give you a hand with the releasing process.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
