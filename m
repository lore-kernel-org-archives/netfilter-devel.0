From: Steve Snodgrass <ssnodgra@pheran.com>
Subject: Bug in documentation for --syn?
Date: Tue, 22 Oct 2002 22:44:05 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021022224405.A26768@cruncher.pheran.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I was looking at the documentation and code for --syn in 1.2.7a (and earlier
versions) and the man page appears to be a little confused on this point.
It states:

"Only match TCP packets with the SYN bit set and the ACK and FIN bits cleared."

but then goes on to say...

"It is equivalent to --tcp-flags SYN,RST,ACK SYN."

Shouldn't that first part read like this?

"Only match TCP packets with the SYN bit set and the ACK and RST bits cleared."
                                                             ^^^

The code backs this up as well (from libipt_tcp.c):

        case '3':
                if (*flags & TCP_FLAGS)
                        exit_error(PARAMETER_PROBLEM,
                                   "Only one of `--syn' or `--tcp-flags' "
                                   " allowed");
                parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert);

Or am I just missing something here?  Thanks!

-- 
Steve Snodgrass * ssnodgra@pheran.com * Network and Unix Guru(?) at Large
Geek Code: GCS d? s: a C++ US++++$ P+++ L+ w PS+ 5++ b++ DI+ D++ e++ r+++ y+*
"If you want to be somebody else, change your mind."  -Sister Hazel
