From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: pom-ng TRACE patch: unable to find ladd slot in src
 ./net/ipv6/Config.in
Date: Tue, 17 Feb 2004 23:00:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402172259200.3844-100000@filer.marasystems.com>
References: <5.2.1.1.2.20040217180044.00b196a0@wheresmymailserver.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Robby <inet6@mail.be>
In-Reply-To: <5.2.1.1.2.20040217180044.00b196a0@wheresmymailserver.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 Feb 2004, Robby wrote:

> Testing TRACE... not applied
> The TRACE patch:
>     Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>     Status: Testing.
> [...]
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] t
> unable to find ladd slot in src ./net/ipv6/Config.in
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?]


Kernel version?

Mind to try to make a patch to correct the problem?

(the first line of the ladd file is the line after which the new option 
should be added)

Regards
Henrik
