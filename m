From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] conntrack-tools 1.4.0 release
Date: Mon, 8 Oct 2012 14:53:31 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210081451430.4431@nerf07.vanv.qr>
References: <20121008115021.GA26222@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48787 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2JHMxc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:53:32 -0400
In-Reply-To: <20121008115021.GA26222@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>The Netfilter project proudly presents:
>
>        conntrack-tools 1.4.0
>
>This release adds the user-space helper infrastructure which includes
>the RPC portmapper (to support NFSv3) and Oracle*TNS helpers.

conntrack-tools-1.4.0 wants a libnetfilter_cthelper-1.0.0, but this has 
not been announced so far.
