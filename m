From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: Fix --with-kernel for libnfnetlink
Date: Thu, 20 Apr 2006 18:50:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0604201844440.18935@mercury.sdinet.de>
References: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <beunlovable@gmail.com>
In-Reply-To: <859616420604200825o71f81878lbbb45251f1e0330d@mail.gmail.com>
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

On Thu, 20 Apr 2006, David Vogt wrote:

> Amin Azez has helped me with some trouble concerning the compilation
> of libnfnetlink.
> The --with-kernel parameter for the configure script did not work as
> intended, so Amin has proposed the following changes that 1) look for
> the kernel sources 2) recognise --with-kernel parameter.

[...]

> + if test "$with_kernel" = ""; then
> +   KERNEL="`uname -r`"
> + else
> +   KERNEL="$with_kernel"
> + fi

Shouldn't --with-kernel let me specify a kernel source directory, instead 
of a kernel version and then using some heuristicts to find the source 
directory? (The heuristic for the default using /lib/modules/`uname 
-r`/build is fine)

(My used kernel sources for example live under ~/kernel/....)

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around it.
(John Gilmore on http://www.cygnus.com/~gnu/)
