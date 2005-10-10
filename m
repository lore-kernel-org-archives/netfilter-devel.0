From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH nfsim] tcpsession: implement the RESET command
Date: Mon, 10 Oct 2005 13:51:46 +0200
Message-ID: <20051010115146.GB25457@roonstrasse.net>
References: <20050922082404.GC21617@roonstrasse.net>
	<1128707631.5611.0.camel@localhost.localdomain>
	<20051008090622.GA9337@roonstrasse.net>
	<1128940663.5611.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1128940663.5611.76.camel@localhost.localdomain>
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

On 2005/10/10 12:37, Rusty Russell <rusty@rustcorp.com.au> wrote:
> OK, I've merged them all, with a fair bit of rewriting to do with the
> backtick code (yeah, I gave in).  The main change (other than cleaning
> up the allocations using talloc and using popen) is that extensions must
> be in $NFSIM_EXTPATH.  This defaults to tools/extensions/ if we're in
> the build dir, or /usr/lib/nfsim/ otherwise.  Does this make sense to
> you?

That assumes that nfsim provides the extensions, or that extensions
have to be installed in one of those paths.  IMHO, the extensions may
be shipped along with a test.  e.g. my h323 tests ship their own
tools.  To make testing easy, it should be possible to use extensions
without installing them (i.e. without root access?).

It also assumes that you _only_ use programs in /usr/lib/nfsim/ - what
if someone wants to call a program in /usr/bin/?  This lockout gives
us no advantage.

I'd prefer to just prepend ".:/usr/lib/nfsim:" to $PATH and let the shell
search, instead of manually prepending extension_path+"/" to the
command.

I'd also rename the default path to /usr/lib/nfsim/extensions, to make
room for more nfsim related files in the future.

> PS.  If you want to send your utils and h323 tests for inclusion,
> please do!

Sure.

Max
