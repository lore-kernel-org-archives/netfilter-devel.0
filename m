From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] [connlimit] Revert 44bd4de9
Date: Mon, 14 Feb 2011 16:45:22 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102141644400.14613@obet.zrqbmnf.qr>
References: <4D594A8D.5040600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	Patrick McHardy <kaber@trash.net>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D594A8D.5040600@linux.vnet.ibm.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 2011-02-14 16:30, Stefan Berger wrote:

> I have to revert the early loop termination in connlimit since it generates
> problems when an iptables statement does not use -m state --state NEW before
> the connlimit match extension.

What problems? Why would xt_connlimit care about what other extensions 
have been used before it?
