From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: netflow/sflow & Linux
Date: Tue, 23 Mar 2004 00:00:36 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403222123480.21687-100000@filer.marasystems.com>
References: <20040322154543.GA11903@oasis.frogfoot.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Abraham van der Merwe <abz@frogfoot.net>
In-Reply-To: <20040322154543.GA11903@oasis.frogfoot.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 22 Mar 2004, Abraham van der Merwe wrote:

> Yes, I know about that, but ntop is rather limited because it is just based
> on libpcap.

I don't see what is wrong with that.

>  (a) keep a "flow" in kernel space AND record routing information (e.g. AS
>      numbers would by extremely useful although we'd need some way for Zebra
>      to pass this information to the kernel).

You could just as well extend ntop/nprobe to get AS numbers from Zebra.  
This way you do not need to burden the kernel with stream reassebly of
forwarded traffic etc for the more advanced flow analyses.

>  (b) export that flow to userspace again.
> 
> My main gripe with ntop is that it can't record AS numbers. This is very
> useful!

Neither can the kernel without modifications. AS numbers exists in
userspace.

> It also means that were missing out on connection tracking which
> would've been really useful (this is something Cisco, etc can't do yet).

Why bloat the kernel with connection tracking only for netflow statistics?

Regards
Henrik
