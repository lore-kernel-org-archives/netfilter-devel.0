From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Sparc64 U60: no iptables
Date: Mon, 10 Oct 2005 11:16:11 -0700 (PDT)
Message-ID: <20051010.111611.106200571.davem@davemloft.net>
References: <4349614F.1010408@frankengul.org>
	<20051009.202646.70198053.davem@davemloft.net>
	<20051010082507.GA5157@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: debian-sparc@lists.debian.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751140AbVJJSQM@vger.kernel.org>
To: seb@frankengul.org
In-Reply-To: <20051010082507.GA5157@frankengul.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: seb@frankengul.org
Date: Mon, 10 Oct 2005 10:25:07 +0200

> Indeed they are. Does the patch assume that cpus are numbered in a
> row ?

Yes, and that assumption is incorrect.

> Now, I reverted the patch for ip_tables.c, ip6_tables.c and ebtables.c.
> Everything is working ok (11h uptime).

Right.
