From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack match and locking
Date: Wed, 26 May 2004 18:06:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405261804070.31237-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0405241628000.27895@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0405241628000.27895@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 24 May 2004, Chris Wilson wrote:

> Hi all,
> 
> The conntrack match from POM-ng doesn't appear to do any locking while 
> accessing conntrack structures. Is that a problem?

Not really a problem, the conntrack is locked by the reference from the
skb (packet), and we know there is no others (legally) messing with this
skb while iptables processes it.

Regards
Henrik
