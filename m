From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Fri, 24 Jun 2005 10:39:08 +0200
Message-ID: <42BBC6AC.9010704@trash.net>
References: <20050622225816.97752.qmail@web52903.mail.yahoo.com>	<42BAF48E.70309@trash.net> <20050623.124951.130237121.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rankincj@yahoo.com, chrisw@osdl.org, bdschuym@pandora.be,
	bdschuym@telenet.be, herbert@gondor.apana.org.au,
	netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262606AbVFXIkr@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050623.124951.130237121.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David S. Miller wrote:
> I have the patch, can you give me a nice changelog entry
> for it?

Here you go:

In 2.6.12 we started dropping the conntrack reference when a packet
leaves the IP layer. This broke connection tracking on a bridge,
because bridge-netfilter defers calling some NF_IP_* hooks to the bridge
layer for locally generated packets going out a bridge, where the
conntrack reference is no longer available. This patch keeps the
reference in this case as a temporary solution, long term we will
remove the defered hook calling. No attempt is made to drop the
reference in the bridge-code when it is no longer needed, tc actions
could already have sent the packet anywhere.

Regards
Patrick
