From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: only first TCP SYN packet consulted in nat table chains - bug
 or feature?
Date: Tue, 22 Jun 2004 15:19:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406221516540.21321-100000@filer.marasystems.com>
References: <20040621200651.GB1323@iceberg.elsat.net.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Krzysztof Rusocki <kszysiu@iceberg.elsat.net.pl>
In-Reply-To: <20040621200651.GB1323@iceberg.elsat.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 21 Jun 2004, Krzysztof Rusocki wrote:

> For really long period of time I used
> rule created by the following iptables combo:
> 
> iptables -t nat -A POSTROUTING -o ppp0 -p tcp --tcp-flags SYN,RST SYN \
> 	-m tcpmss --mss 1453: -j TCPMSS --set-mss 1452
> 
> However, quite recently I discovered
> that first TCP SYN packet's MSS is altered
> and latter SYN packets (in case of retransmission)
> have MSS unchanged (1460 - ether).

Yes. This is by definition of the nat table.

The nat table is consulted to set up the NAT mappings of NEW sessions
only. It is not a packet mangler.. To process all (selected) packets you
should use the mangle or filter tables.

If you need to remember something related to a specific session between
packets then see the CONNMARK patch in pom-ng.

Regards
Henrik
