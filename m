From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: string match patch
Date: Tue, 13 Jul 2004 02:33:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407130227100.23959-100000@filer.marasystems.com>
References: <002a01c46862$6e77df90$0200a8c0@milchreis>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick <patrick_@freenet.de>
In-Reply-To: <002a01c46862$6e77df90$0200a8c0@milchreis>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 13 Jul 2004, Patrick wrote:

> yes I know that I am supposed to have new menu entries .. but as I said the
> patch pretends to be applied correctly and also the header files are copied
> .. I am using most recent version of pom-ng, thus
> "patch-o-matic-ng-20040621"
> I also tried the old stable version of patch-o-matic-20031219 .. which did
> not work either :|


Seems to be some bug in the pom-ng runme script..

There is a .ladd file for adding the menu entry, but for some reason it
does not get added and the runme does not complain either..

For now manually add the missing menu entry.

Regards
Henrik
