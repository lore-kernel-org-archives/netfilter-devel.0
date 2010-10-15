From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: event-driven connection tracking
Date: Fri, 15 Oct 2010 09:17:08 +0200
Message-ID: <4CB7FFF4.8030807@netfilter.org>
References: <4CB5CF17.3090302@googlemail.com> <alpine.LNX.2.01.1010131747460.27120@obet.zrqbmnf.qr> <4CB6302A.8080507@googlemail.com> <alpine.LNX.2.01.1010140053190.5698@obet.zrqbmnf.qr> <4CB6F1E2.3030702@netfilter.org> <4CB704F7.60608@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39936 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0JOHRM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:17:12 -0400
In-Reply-To: <4CB704F7.60608@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14/10/10 15:26, Mr Dash Four wrote:
> Another constraint I have (which I did not mention in my initial post)
> is that, for various reasons, I am using the 2.6.16.60 kernel - the
> libnetfilter_conntrack requirements suggest I can get away with it, is
> there anything in particular I should be aware of when installing/using
> this package with this kernel version (no, I am not in a position to
> upgrade - not yet!)?

Recommended kernel version is >= 2.6.18 (that's on the website and
docs). With such an old kernel version, I think that you may have
problems with NAT conntrack entries.

Let me know anyway how it goes, it would be interesting to know.
