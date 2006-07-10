From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: FYI: Solved a dynamic linking loader issues with iptables,libiptc
 and perl
Date: Mon, 10 Jul 2006 13:52:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0607101324440.5305@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Cc: hawk@comx.dk
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.61.0607101324442.5305@ask.diku.dk>
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


Hi Google

(This is a weird message, as I already have solved my problem... When I
searhed google I only found questions about this issue and no answers.
Thus, this post will provide an answer)

The error message I experinced was:
  Couldn't load target `standard':/usr/local/lib/iptables/libipt_standard.so: undefined symbol: register_target

This issue is caused when loading a dynamic library via ldopen(3). The
problem here is that the loaded library cannot resolve/find external
symbol "register_target" which is defined in iptables.o.

The reason this error occured, in my case, was that I also loaded the
library containing iptables.o dynamically (through perl).  The problem
with this is that the default behavior of ldopen(3) is NOT to export
symbols defined in the library (default flag RTLD_LOCAL).  Thus, the
solution was to set the flag RTLD_GLOBAL when loading the library.

>From man dlopen(3):
  "... RTLD_GLOBAL may be or'ed into flag, in which case the external
  symbols defined in the library will be made available for symbol
  resolution of subsequently loaded libraries."

With perl and DynaLoader, this RTLD_LOCAL flag is set by defining:
  sub dl_load_flags { 0x01 }

(What am I doing: I'm interfacing with libiptc and iptables do_command
from Perl (p.s. I hate perl XS code... but now it finally works...))


Med venlig hilsen / Best regards
   Jesper Brouer
   ComX Networks A/S
   Linux Network developer
   Cand. Scient Datalog / MSc.
   Author of http://adsl-optimizer.dk



Questions found via Google...

"About the iptc library":
http://lists.netfilter.org/pipermail/netfilter-devel/2003-March/010783.html
  This post, has experinced the problem I describe...

"Compilation problem??":
http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015937.html
  This post, he simply need to compile with option "-rdynamic" or "--export-dynamic".
