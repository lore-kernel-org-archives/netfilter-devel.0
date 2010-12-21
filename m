From: David Miller <davem@davemloft.net>
Subject: Re: [ANNOUNCE] libmnl 1.0.0 release
Date: Tue, 21 Dec 2010 12:22:25 -0800 (PST)
Message-ID: <20101221.122225.39203217.davem@davemloft.net>
References: <4D0CABC3.3090601@netfilter.org>
	<alpine.LNX.2.01.1012181633390.13544@obet.zrqbmnf.qr>
	<4D110BDC.4000709@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, lists@sterenborg.info,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D110BDC.4000709@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 21 Dec 2010 21:19:40 +0100

> I think that this approach (see patch) is safe to fix this problem.

This is fine for now, but really you should have a copy of the
headers in your tree.

It's the only way to sanely control the build in all possible
scenerios.  The kernel headers are just too large of a variable
for things like this.
