From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Maximum chain name length
Date: Mon, 8 Dec 2003 13:17:44 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312081311370.10693-100000@filer.marasystems.com>
References: <1070883753.1932.7.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1070883753.1932.7.camel@jasiiitosh.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 8 Dec 2003, John A. Sullivan III wrote:

> Is there any way to extend the maximum allowed chain name length in
> iptables? Thanks - John

You can change the limit by redefining IPT_FUNCTION_MAXNAMELEN in
include/linux/netfilter_ipv4/ip_tables.h, but this will render any
binaries compiled with the old length unuseable and also considerably
increases the kernel memory usage of iptables as the maximum space is
allocated for each rule even if it uses a long chain name or not.

If you really need this long names I would recommend you to just use 
abstract names in the kernel and save a index file on the system for 
in-field analysis. By using a small wrapper you can even have the names 
translated automatically if you like.

Regards
Henrik
