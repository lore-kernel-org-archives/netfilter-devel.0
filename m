From: "David S. Miller" <davem@davemloft.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 28 Jun 2005 16:07:11 -0700 (PDT)
Message-ID: <20050628.160711.91199588.davem@davemloft.net>
References: <42BAF48E.70309@trash.net>
	<20050623.124951.130237121.davem@davemloft.net>
	<42BBC6AC.9010704@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rankincj@yahoo.com, chrisw@osdl.org, bdschuym@pandora.be,
	bdschuym@telenet.be, herbert@gondor.apana.org.au,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262254AbVF1Xnh@vger.kernel.org>
To: kaber@trash.net
In-Reply-To: <42BBC6AC.9010704@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 24 Jun 2005 10:39:08 +0200

> In 2.6.12 we started dropping the conntrack reference when a packet
> leaves the IP layer. This broke connection tracking on a bridge,
> because bridge-netfilter defers calling some NF_IP_* hooks to the bridge
> layer for locally generated packets going out a bridge, where the
> conntrack reference is no longer available. This patch keeps the
> reference in this case as a temporary solution, long term we will
> remove the defered hook calling. No attempt is made to drop the
> reference in the bridge-code when it is no longer needed, tc actions
> could already have sent the packet anywhere.

Patch applied and pushed to stable@kernel.org

Thanks a lot.
