From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Module compilation?
Date: Wed, 7 Jan 2004 17:05:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401071704360.4717-100000@filer.marasystems.com>
References: <007801c3d415$0ef89640$6b00a8c0@hfkdz92r69c0ua>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: UnderLord <ekin0x@phreaker.net>
In-Reply-To: <007801c3d415$0ef89640$6b00a8c0@hfkdz92r69c0ua>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 6 Jan 2004, UnderLord wrote:

> Hello all,
> 
>     I just made a tiny module (which is a small hack of the MIRROR module)
> and I don't
> know how to compile it properly. The Netfilter hacking documentation does
> not refer to this and
> the Makefile refers to a main Makefile but I can't figure out which one.
> That's why I'm asking your help here.

See the gcc line when you compile kernel modules for your kernel. Then 
copy the options and call gcc manually for compiling your module.

Regards
Henrik
