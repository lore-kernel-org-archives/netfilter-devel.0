From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Debugging NAT problems in the kernel level
Date: Thu, 26 Jul 2007 12:19:47 +0100
Message-ID: <46A88353.5050702@ufomechanic.net>
References: <3ed55890707251129n42c7f0c6w54524e768bd591ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: liran tal <liransgarage@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <3ed55890707251129n42c7f0c6w54524e768bd591ae@mail.gmail.com>
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

* liran tal wrote, On 25/07/07 19:29:
> Dear developers,
> 
> I've posted before about the NAT or ip_conntrack problem that I have with
> kernel 2.4.17_mvl21-malta-mips which was modified by other vendors as well
> on it's way to me and it is suffering from a *serious* networking issue where
> NAT is not working in the kernel level.
> 
> I need help with tools and knowledge on how to debug, diagnose and figure
> out what exactly is the problem and where is it coming from.
> If required, I'll be happy to provide access to the kernel sources that I have
> for further reviewing or posting just the relevant parts here.
> 
> 
> I've given it a go myself and I need a guiding hand.
> I will appreciate any post and comment on this subject.


It may help to reduce it to the nearest official kernel source + patches.

Realising that some kernels are effectively patched so heavily as to be
almost the same as a subsequent release that they are given the same
version number as the subsequent release when in fact they will be
missing other aspects.

So try and find the base kernel, and get the source to that and use diff
-Nru to see what has changed.

Then, google fragments of the diff (or search this list) and try and
work out what patch-set they are part of.

When you assemble a collection of patch-sets each providing some certain
 fix or feature you will understand how and why that kernel was put
together so.

If you look at conversations that occur around the patches that google
found, you may find later versions of those patches or discussions of
bugs they contain.

Or, you may take a later base kernel and try to apply your patches to
those (where relevant).

But in the end you may need to become intimately familiar with the code.

A other tool that may help trigger the error is tomahawk for replaying
pcap captures in real time (with "expect" like capabilities).

Expect to add lots of printk in the kernels as you dbug.

Also, use "quilt" to manage the various patches, it makes life much easier.

Sam
