From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH nfsim] tcpsession: implement the RESET command
Date: Mon, 10 Oct 2005 23:03:30 +1000
Message-ID: <1128949410.5611.105.camel@localhost.localdomain>
References: <20050922082404.GC21617@roonstrasse.net>
	<1128707631.5611.0.camel@localhost.localdomain>
	<20051008090622.GA9337@roonstrasse.net>
	<1128940663.5611.76.camel@localhost.localdomain>
	<20051010115146.GB25457@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20051010115146.GB25457@roonstrasse.net>
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

On Mon, 2005-10-10 at 13:51 +0200, Max Kellermann wrote:
> On 2005/10/10 12:37, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > OK, I've merged them all, with a fair bit of rewriting to do with the
> > backtick code (yeah, I gave in).  The main change (other than cleaning
> > up the allocations using talloc and using popen) is that extensions must
> > be in $NFSIM_EXTPATH.  This defaults to tools/extensions/ if we're in
> > the build dir, or /usr/lib/nfsim/ otherwise.  Does this make sense to
> > you?
> 
> That assumes that nfsim provides the extensions, or that extensions
> have to be installed in one of those paths.  IMHO, the extensions may
> be shipped along with a test.  e.g. my h323 tests ship their own
> tools.  To make testing easy, it should be possible to use extensions
> without installing them (i.e. without root access?).

I assumed you would want to merge your tests into nfsim-testsuite...

> It also assumes that you _only_ use programs in /usr/lib/nfsim/ - what
> if someone wants to call a program in /usr/bin/?  This lockout gives
> us no advantage.
> 
> I'd prefer to just prepend ".:/usr/lib/nfsim:" to $PATH and let the shell
> search, instead of manually prepending extension_path+"/" to the
> command.
> 
> I'd also rename the default path to /usr/lib/nfsim/extensions, to make
> room for more nfsim related files in the future.

OK, how about this:
(1) Use $NFSIM_EXTPATH if set, else
(1) Use ".:tools/extensions:$PATH" if we're in the nfsim dir, else
(2) Use ".:/usr/lib/nfsim/extensions:$PATH" if we're not.

I'll patch it now...
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
