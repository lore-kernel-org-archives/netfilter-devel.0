From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: little question...
Date: Thu, 19 Jul 2007 13:34:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707191334230.30033@fbirervta.pbzchgretzou.qr>
References: <885896af0707190355l614f56f9r2ec4f6501f65a345@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <885896af0707190355l614f56f9r2ec4f6501f65a345@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


> Sorry, i need a little help...
> I need to write a module of the kernel.
> It will consist let's say in 5 different files.
> Actually, i am using EXPORT_SYMBOL to make each symbol needed
> in a file from another...
> ..but in the end i have 5 different modules...
> Instead, i want just ONE module, made up of 5 files...
> Is there a simple example of writing a Makefile that does this?

https://dev.computergmbh.de/svn/misc_kernel/oopser/trunk/


	Jan
-- 
