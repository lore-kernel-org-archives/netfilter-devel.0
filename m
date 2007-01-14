From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Sun, 14 Jan 2007 21:10:45 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
References: <20070114192011.GA6270@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751659AbXANUMf@vger.kernel.org>
To: David Madore <david.madore@ens.fr>
In-Reply-To: <20070114192011.GA6270@clipper.ens.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Jan 14 2007 20:20, David Madore wrote:
>
>Implement TCPMSS target for IPv6 by shamelessly copying from
>Marc Boucher's IPv4 implementation.
>
>Signed-off-by: David A. Madore <david.madore@ens.fr>

Would not it be worthwhile to merge ipt_TCPMSS and
ip6t_TCPMSS to xt_TCPMSS instead?


	-`J'
-- 
