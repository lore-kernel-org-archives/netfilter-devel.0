From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Changing the content of tcp timeouts in ip_conntrack_proto_tcp.c
Date: Wed, 14 Jan 2004 12:11:37 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401141203530.29640-100000@filer.marasystems.com>
References: <40051B18.40004@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <40051B18.40004@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Jan 2004, Emmanuel Guiton wrote:

> In the target module I'm writing, I need to customize the values 
> ip_ct_tcp_timeout_/somthing/ in the ip_conntrack_proto_tcp.c file. I 
> tried to write an extern function on the model of ip_ct_refresh, but I 
> always got the same problem with depmod:
> 
> depmod: *** Unresolved symbols in 
> /lib/modules/2.4.23/kernel/net/ipv4/netfilter/ipt_MY_TARGET.o
> depmod:     ip_ct_proto_tcp_set_timeouts
> 
> Does someone have a good advice on how to proceed correctly?

Looks like you have not exported this function from ip_conntrack. To use a 
function from another module than it is defined in the function must first 
be exported from the module where it is defined.

Regards
Henrik
