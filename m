From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: skip checksum verification for outgoing
 rejected ipv6 packets
Date: Wed, 23 Oct 2013 11:22:08 +0200
Message-ID: <20131023092208.GA4938@localhost>
References: <20131022083631.GA28194@stfomichev-desktop>
 <20131022105540.GD12157@breakpoint.cc>
 <20131022124323.GB3255@stfomichev-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net, fw@strlen.de
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39320 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3JWJWT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:22:19 -0400
Content-Disposition: inline
In-Reply-To: <20131022124323.GB3255@stfomichev-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 22, 2013 at 04:43:23PM +0400, Stanislav Fomichev wrote:
> Don't verify checksum for outgoing packets because checksum calculation
> may be done by the device.
> 
> Without this patch:
> $ ip6tables -I OUTPUT -p tcp --dport 80 -j REJECT --reject-with tcp-reset
> $ time telnet ipv6.google.com 80
> Trying 2a00:1450:4010:c03::67...
> telnet: Unable to connect to remote host: Connection timed out
> 
> real    0m7.201s
> user    0m0.000s
> sys     0m0.000s
> 
> With the patch applied:
> $ ip6tables -I OUTPUT -p tcp --dport 80 -j REJECT --reject-with tcp-reset
> $ time telnet ipv6.google.com 80
> Trying 2a00:1450:4010:c03::67...
> telnet: Unable to connect to remote host: Connection refused
> 
> real    0m0.085s
> user    0m0.000s
> sys     0m0.000s

Applied to nf-next, thanks!
