From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problems using custom module
Date: Mon, 10 Nov 2003 22:13:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311102211480.6564-100000@filer.marasystems.com>
References: <115121565453.20031110195805@net.ipl.pt>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: IPLNet - PedroRibeiro <pribeiro-bulk@net.ipl.pt>
In-Reply-To: <115121565453.20031110195805@net.ipl.pt>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 10 Nov 2003, IPLNet - PedroRibeiro wrote:

> >> iptables v1.2.7a: Couldn't load match
> >> `ttlhhd':/lib/iptables/libipt_ttlhhd.so: cannot open shared object
> >> file: No such file or directory

This error is not related to the kernel but to the userspace iptables 
program. As the kernel the userspace program also uses modules but of a 
slightly different kind. The userspace module is responsible for parsing 
the arguments given to the iptables command into the suitable match/target 
structure sent to the kernel.

See the userspace/extensions/ directory.

Regards
Henrik
