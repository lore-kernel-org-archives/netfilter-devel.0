From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH nfsim] tcpsession: implement the RESET command
Date: Mon, 10 Oct 2005 15:14:37 +0200
Message-ID: <20051010131437.GA25965@roonstrasse.net>
References: <20050922082404.GC21617@roonstrasse.net>
	<1128707631.5611.0.camel@localhost.localdomain>
	<20051008090622.GA9337@roonstrasse.net>
	<1128940663.5611.76.camel@localhost.localdomain>
	<20051010115146.GB25457@roonstrasse.net>
	<1128949410.5611.105.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1128949410.5611.105.camel@localhost.localdomain>
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

On 2005/10/10 15:03, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > That assumes that nfsim provides the extensions, or that extensions
> > have to be installed in one of those paths.  IMHO, the extensions may
> > be shipped along with a test.  e.g. my h323 tests ship their own
> > tools.  To make testing easy, it should be possible to use extensions
> > without installing them (i.e. without root access?).
> 
> I assumed you would want to merge your tests into nfsim-testsuite...

I do want that.  But there is a reason nfsim-testsuite is separate
from nfsim itself, and the extensions (like my generate-h225-packet
tool) are co-developed with the tests using it, not with nfsim itself.

> OK, how about this:
> (1) Use $NFSIM_EXTPATH if set, else
> (1) Use ".:tools/extensions:$PATH" if we're in the nfsim dir, else
> (2) Use ".:/usr/lib/nfsim/extensions:$PATH" if we're not.

Why don't you add all of them to $PATH (if set and present)?  I
believe the following order would be best:

 1. "." (or better `dirname $testfile.sim`)
 2. $NFSIM_EXTPATH
 3. $srcdir/tools/extensions
 4. $pkglibdir

It is perfectly possible for a test suite to use extensions included
in nfsim _and_ extensions the test suite itself shipped.

This also makes the code simpler.

Max
