From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] nftables 0.6 release
Date: Thu, 2 Jun 2016 20:44:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1606022042440.8683@nerf40.vanv.qr>
References: <20160602165940.GA1874@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:42970 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174AbcFBSoT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 14:44:19 -0400
In-Reply-To: <20160602165940.GA1874@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2016-06-02 18:59, Pablo Neira Ayuso wrote:
>Resources
>=========
>The nftables code can be obtained from:[...]
>To build the code, libnftnl 1.0.6 and libmnl >= 1.0.2 are required:

According to configure.ac, libnftnl >=1.0.5 and libmnl >=1.0.3
are requested. Something probably needs a bump if the dependencies
have tightened.
