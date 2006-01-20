From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x_tables: fix alignment on [at least] ppc32
Date: Fri, 20 Jan 2006 01:43:26 -0800 (PST)
Message-ID: <20060120.014326.99470463.davem@davemloft.net>
References: <20060120004512.GT4603@sunbeam.de.gnumonks.org>
	<20060119.165635.104653932.davem@davemloft.net>
	<17360.44337.425946.347577@alkaid.it.uu.se>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750770AbWATJtG@vger.kernel.org>
To: mikpe@csd.uu.se
In-Reply-To: <17360.44337.425946.347577@alkaid.it.uu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mikael Pettersson <mikpe@csd.uu.se>
Date: Fri, 20 Jan 2006 10:28:17 +0100

> ACK. Both Harald's patch and DaveM's simplification of it
> (simply s/void */u_int64_t/g in XT_ALIGN()) fix the iptables
> problems on my ppc32 box.

Thanks for testing.
