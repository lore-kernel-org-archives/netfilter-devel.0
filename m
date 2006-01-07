From: Chris Lowth <chris@lowth.com>
Subject: Re: Linux 2.6 support for "rope" match module
Date: Sat, 07 Jan 2006 13:37:55 +0000
Message-ID: <43BFC433.3040102@lowth.com>
References: <43BA5CCB.6050207@lowth.com>
	<Pine.LNX.4.61.0601051117590.21555@yvahk01.tjqt.qr>
	<43BCFE09.9070303@lowth.com>
	<20060106144921.GG4898@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060106144921.GG4898@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>Chris, see, you might be new to this, so I give you some hints:
>
>A number of people (in)frequently attempt to do a couple of things that
>just ring all the alarm bells of kernel hackers.  Some of those are:
>
>1) c++ in the kernel
>2) bytecode interpreters (e.g. forth) in the kernel
>3) floating point in the kernel
>
>  
>
Harald, thanks for taking the time comment.

Just to say: I have endeavoured to avoid the pitfalls associated with a 
general-purpose byte-code interpreter for the kernel. I rather see it as 
another point at which the kernel can be instructed to take actions 
through a user-process supplied structure - rather like routing tables, 
and netfilter itself - it's not really the equivalent of embedding a 
"forth" or "perl" interpreter into the kernel.

I have kept the rope module language very restricted in order to make it 
"kernel friendly". Hence...

1) it has no access to any system features or data except for the packet 
being matched and it's netfilter-related structures.
2) it has very limited string handling capability (no buffer copying is 
required by the vast majority of scripts) - so: no need for garbage 
collection etc. In fact I intended to strip out string buffer copying 
out entirely in a couple of releases time.
3) very limited script size - scripts are typically only a few lines in 
length.
4) tight restrictions on the number of times a loop can "spin" - so 
"while" loops etc cant cause blockages
5) enforced restrictions on the number of "actions" (instructions) a 
single script can perform.
6) no I/O is possible
7) no dynamic memory allocation required or allowed at run time.
8) my target is that a rope script exeucting 5 or more steps that are 
already available in other netfilter modules should be at least as fast 
as a netfilter chain containing those steps. The more "steps" used in 
the comparison - the better it gets. [though there is still scope for 
improvement in this arena].

Does this (in part, at least) address your concerns?

Chris
