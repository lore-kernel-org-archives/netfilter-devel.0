From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Conntrack SIP Problem
Date: Mon, 18 Jun 2007 14:34:57 +0200
Message-ID: <46767BF1.9070904@trash.net>
References: <Pine.LNX.4.64.0706161524130.980@knorkaan.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
To: Jerome Borsboom <netfilter-devel@knorkaan.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706161524130.980@knorkaan.xs4all.nl>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jerome Borsboom wrote:
> This is a CC of a patch from my discussion on linux-net mailinglist
> which may be also appropriate here.


It wasn't CCed so I've added linux-net since you've also posted
the patch there.

> Below is a patch that I had to include on top of Herbert Xu's recent
> nat-sip patch to get my SIP setup working:
> 
>     [NETFILTER]: sip: Fix RTP address NAT
> 
> My setup is a Fritzbox SIP-client behind a NAT-firewall that talks to a
> server on the internet. The first chunk of the patch was not necessary
> to get the setup working, but I think it is more correct to include it.
> The idea behind it is that DNAT of the the RTP session is only necessary
> if the SIP session has been SNATed. The second chunk adds some SIP
> messages that must be processed as they contain SDP information in my case.


Thanks. They both look OK, but for 2.6.22 I'm only going to add
the new message types. I'll queue the first chunk for 2.6.23.
Can you please send me a Signed-off-by: line for your patch?

