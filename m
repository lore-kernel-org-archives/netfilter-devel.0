From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: Changing packet data {Virus Scanned}
Date: Mon, 19 Apr 2004 00:13:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404190011040.8839-100000@filer.marasystems.com>
References: <200404181915.i3IJFpFq024266@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "=?windows-1257?Q?'Piotr_Gasid=F9o'?=" <quaker@pandora.barbara.eu.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Qiang <qzhang@endeavorsystems.net>
In-Reply-To: <200404181915.i3IJFpFq024266@localhost.localdomain>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 18 Apr 2004, Qiang wrote:

> Sounds interesting, do you think the function exported From
> ip_NAT_helper.c ip_nat_mangle_tcp_packet can be directly used To achieve
> this?

Maybe, and is why I mentioned it.

It is not intended to be used outside of NAT helpers, but maybe it works 
if done carefully. And again, don't forget the proper locking.

Regards
Henrik
