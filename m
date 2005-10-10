From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH nfsim] tcpsession: implement the RESET command
Date: Mon, 10 Oct 2005 20:37:43 +1000
Message-ID: <1128940663.5611.76.camel@localhost.localdomain>
References: <20050922082404.GC21617@roonstrasse.net>
	<1128707631.5611.0.camel@localhost.localdomain>
	<20051008090622.GA9337@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20051008090622.GA9337@roonstrasse.net>
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

On Sat, 2005-10-08 at 11:06 +0200, Max Kellermann wrote:
> Hi Rusty,
> 
> I have already reworked the 2.6.14 patch, because the old one was not
> fully working.  I havn't sent them to the list yet, but I have
> published them on my nfsim page:
> 
>  http://max.kellermann.name/projects/netfilter/nfsim.html
> 
> I'm not at home currently, next week I'll rewrite the patchset to
> apply on the current nfsim trunk (unless you have dealt with them
> already in their current form).

OK, I've merged them all, with a fair bit of rewriting to do with the
backtick code (yeah, I gave in).  The main change (other than cleaning
up the allocations using talloc and using popen) is that extensions must
be in $NFSIM_EXTPATH.  This defaults to tools/extensions/ if we're in
the build dir, or /usr/lib/nfsim/ otherwise.  Does this make sense to
you?

I haven't tested it, though 8(.

At Harald's suggestion, I'm trying for an actual nfsim release, but I
want to make two big changes before then:

(1) Use VPATH rather than actually copying the files from the source
dir, and use the Makefile in the netfilter/ dir in >=2.6.14.
(2) netlink support.

Feedback welcome!
Rusty.
PS.  If you want to send your utils and h323 tests for inclusion, please
do!
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
