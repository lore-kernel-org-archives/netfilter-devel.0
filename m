From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problem in Plugging into Netfilters Hooks
Date: Thu, 29 Apr 2004 15:33:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404291533200.27094-100000@filer.marasystems.com>
References: <s090982c.069@lucius.provo.novell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: A Babula <ababula@novell.com>
In-Reply-To: <s090982c.069@lucius.provo.novell.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 Apr 2004, A Babula wrote:

> I have a written a small module to hook into NF_IP_LOCAL_IN hook .To
> get the packet I initialize the nf_hook_ops structure and passes to the
> `nf_register_hook'   and I do the samething for nf_unregister_hook'. 
> But when I compile following errors are coming.

> static struct nf_hooks_ops nf_hook =

There is an s too many there...

Regards
Henrik
