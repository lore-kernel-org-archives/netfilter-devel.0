From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: 64bit changes in cvs
Date: Fri, 28 May 2004 14:19:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405281413510.7322@tux.rsn.bth.se>
References: <1085609520.969.128.camel@tux.rsn.bth.se> <40B727C9.4090604@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40B727C9.4090604@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 28 May 2004, Pablo Neira wrote:

> Hi Martin,

Hi Pablo

> I sent a patch to add autoconf some time ago, actually to fix this issue
> with 32bit in user space, 64 bit in kernel space architectures.
>
> Well, I just want to reopen some discussion if possible, if you consider
> that autoconf is more than we need for iptables it's ok I will understand.

I know almost nothing about autoconf (more than I think it's very bloated
:), I'll see if I can make some time to actually look at it.

> Please see:
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015245.html
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015246.html
>
> >I've reworked the part of the makefile that tries to detect if you are
> >compiling a 32bit iptables against a 64bit kernel. I hope it works...
> >
> >
>
> What did you use? uname stuff? I'll promise to have a look at CVS when
> having some spare time.

Just remember that I never said it was pretty... :)
I use uname and check the BITS_PER_LONG macro in the kernel we are
compiling against and I try to determine if we are compiling 32bit or
64bit. It isn't pretty but it's an improvement over the previous version.
As that blindly said that uname -m == sparc64 always was 32bit userspace
(and the extra define wasn't propagated to the extensions/ directory)

It seems to do the right(tm) thing on x86, sparc64 (32/64bit userspace)
and alpha, don't have access to more architectures.

/Martin
