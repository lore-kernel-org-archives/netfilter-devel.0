From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libiptc
Date: Wed, 7 Jul 2004 10:54:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407071050550.10840-100000@filer.marasystems.com>
References: <1123133956.20040706105856@rosbi.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: eremin <eremin@rosbi.ru>
In-Reply-To: <1123133956.20040706105856@rosbi.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Jul 2004, eremin wrote:

> How with the libiptc to work with ports? (i.e. source-port or
> dest-port)? If it is impossible, what to use?

Use iptables / iptables-restore, not libiptc.

For details how libiptc works with ports see the source of the 
tcp/udp modules or any other match module working with ports. ports is not 
a primitive in iptables and is implemented via protocol dependent matches 
(extensions directory).

Regards
Henrik
