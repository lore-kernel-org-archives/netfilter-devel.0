From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: link layer hooks
Date: Fri, 9 Jul 2004 10:39:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407091024150.4168-100000@filer.marasystems.com>
References: <003901c464fd$af8ec790$f73824a0@laptop80>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Huadong Liu <hliu@cs.utk.edu>
In-Reply-To: <003901c464fd$af8ec790$f73824a0@laptop80>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 8 Jul 2004, Huadong Liu wrote:

> From the netfilter documentation I know that hooks are inserted in the
> Ipv4, IPv6 and DecNET stack. Is there any link layer hook supported by
> netfilter? I need to process the link layer frames before they go up the
> stack, e.g. ip_rcv(). Is netfilter_bridge for this purpose?

See ebtables.

Regards
Henrik
