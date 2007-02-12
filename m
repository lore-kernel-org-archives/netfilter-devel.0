From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.20-rc4: regression: iptables failed to load rules
Date: Mon, 12 Feb 2007 12:17:14 -0800 (PST)
Message-ID: <20070212.121714.41636131.davem@davemloft.net>
References: <5157576d0701082329o1875911j20f6679e2d35bb17@mail.gmail.com>
	<Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kvarsin@gmail.com, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, linux-kernel@vger.kernel.org,
	bunk@stusta.de
To: torvalds@osdl.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965327AbXBLURR@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701090929160.3594@woody.osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Linus Torvalds <torvalds@osdl.org>
Date: Tue, 9 Jan 2007 09:33:32 -0800 (PST)

> David, please crack some heads.

I have some patches from Patrick in my queue which try to add some
sanity to this situation, we'll see how much better we can make it.
