From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: [ANNOUNCE] nfsim - netfilter simulation environment
Date: Wed, 7 Jan 2004 03:50:10 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040107115010.96814.qmail@web60702.mail.yahoo.com>
References: <200401071044.18059.jeremy@redfishsoftware.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200401071044.18059.jeremy@redfishsoftware.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
  A very nice idea & work indeed. But when i tried to
build the only available snapshot, i got these errors:

[zak@zeenix nfsim]$ make
awk 'BEGIN { FS="=" } /[A-Z0-9_]=(.*)/ { print
"#define "$1" "$2; }' < .config >
kernelenv/include/linux/config.h
doc/gen-help core/tui.c > core/tui.c.helped.c
warning: failed to load external entity
"doc/link-xhtml/xhtml/docbook.xsl"
compilation error: file doc/xhtml.xsl line 8 element
import
xsl:import : unable to load
doc/link-xhtml/xhtml/docbook.xsl
-:1: error: Document is empty
 
^
-:1: error: Start tag expected, '<' not found
 
^
doc/gen-help: line 20: links: command not found
warning: failed to load external entity
"doc/link-xhtml/xhtml/docbook.xsl"
compilation error: file doc/xhtml.xsl line 8 element
import
xsl:import : unable to load
doc/link-xhtml/xhtml/docbook.xsl
-:1: error: Document is empty
 
^
-:1: error: Start tag expected, '<' not found
 
^
doc/gen-help: line 20: links: command not found
gcc -Wstrict-prototypes -Wunused -Wall -g -ggdb -Wa,-W
-I. -I/home/zak/downloads/nfsim/core
-I/home/zak/downloads/nfsim/kernelenv/include
-I/home/zak/downloads/nfsim/netfilter/include  -c -o
core/tui.o core/tui.c.helped.c
core/tui.c.helped.c: In function `tui_help_help':
core/tui.c.helped.c:128: parse error before ')' token
core/tui.c.helped.c: In function `tui_exit_help':
core/tui.c.helped.c:148: parse error before ')' token
make: *** [core/tui.o] Error 1

__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
