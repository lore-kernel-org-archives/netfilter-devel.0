From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: Matching MLD with ip6tables
Date: Tue, 16 Jun 2015 07:45:52 +0200
Message-ID: <20150616054551.GB14231@odroid>
References: <20150501025612.GB2465@odroid>
 <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.passe0815.de ([188.40.49.9]:52276 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbbFPFzT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 01:55:19 -0400
Received: from mail.passe0815.de (localhost [127.0.0.1])
	by mail.passe0815.de (Postfix) with ESMTP id 287AF58668A
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 07:45:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1505010828090.30665@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 01, 2015 at 08:33:03AM +0200, Jan Engelhardt wrote:
> -p matches the first non-extension header. For the
> exthdrs, there is e.g. -m hbh.

Just to check, I guess ebtables is behaving similarly?
For instance
"ebtables -I <CHAIN> -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type 130"
will match MLD queries?

And "-p IPv6 --ip6-proto 0" will *not* match packets with a
hop-by-hop header?

To match extension headers on a bridge
ip6tables/physdev/bridge-nf-call-ip6tables is the only way, right?

Cheers, Linus


PS: Thanks for the quick reply back then, helped me a lot!
