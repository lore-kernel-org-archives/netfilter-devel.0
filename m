From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 15:23:16 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401281521320.6253-100000@filer.marasystems.com>
References: <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, Willy Tarreau <willy@w.ods.org>,
   Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 28 Jan 2004, Harald Welte wrote:

> The question is, again: What ist the desired behaviour?  Should the
> policy be determined on the un-NAT'ed packet or on the NAT'ed one?

IN my opinion it must be on the NAT'ed one, or else there is a very large
risk the packet does not match the selected policy and the other endpoint
will reject the resulting IPSec packet.

Regards
Henrik
