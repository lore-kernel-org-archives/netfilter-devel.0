From: Max Kellermann <max@duempel.org>
Subject: nfsim on amd64: va_list incompatible type error
Date: Fri, 7 Jan 2005 00:57:48 +0100
Message-ID: <20050106235748.GA23714@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

I'm trying to get nfsim running on my Athlon 64.. (nfsim is definitely
cool stuff! I'll use it to test my H.323 ct helper module)

The easiest thing first: the README should mention that you need the
libreadline headers to compile (libreadline4-dev on Debian).

I applied Patrick's 4 patches to my svn/trunk working copy, they fixed
a lot of error messages concerning 64 bit portability. Plus, I had to
add 24 dummy bytes to pad cmdline_option (also Patrick's idea).

gcc -Wmissing-prototypes -Wstrict-prototypes -Wunused -Wall -g -Wa,-W
-I. -I/home/max/svn/nfsim/core -I/home/max/svn/nfsim/kernelenv/include
-I/home/max/svn/nfsim/netfilter/include  -c -o core/talloc.o
core/talloc.c
core/talloc.c: In function `talloc_vasprintf':
core/talloc.c:862: error: incompatible types in assignment
core/talloc.c:868: error: incompatible types in assignment
core/talloc.c: In function `talloc_vasprintf_append':
core/talloc.c:906: error: incompatible types in assignment
core/talloc.c:918: error: incompatible types in assignment

both gcc 1:3.3.5-5 and 3.4.3-6 (Debian) are affected. I found several
references to this behaviour on the net, one is a gcc bug report:

 http://gcc.gnu.org/bugzilla/show_bug.cgi?id=8262

.. but I fail to understand how to go around this limitation. When I
defined HAVE_VA_COPY as a workaround, the error went away. Where is
HAVE_VA_COPY meant to be defined?

nfsim works now, although most tests from nfsim-testsuite fail, is
that correct?  (on my P4 @work, nfsim segfaults, I'll analyze that
tomorrow).

Max
