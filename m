From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE]: Release of nftables 0.2
Date: Fri, 18 Apr 2014 14:29:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1404181426500.27921@nerf08.vanv.qr>
References: <20140414113933.GA20756@macbook.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:58791 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaDRM3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:29:50 -0400
In-Reply-To: <20140414113933.GA20756@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2014-04-14 13:39, Patrick McHardy wrote:

>The netfilter project presents:
>
>	nftables 0.2

Seeing that the last release was 0.099, the package manager algorithms 
are telling me that

	$ zypper vcmp 0.099 0.2
	0.099 is newer than 0.2

Solvable on the packaging level, but awkward nevertheless.
