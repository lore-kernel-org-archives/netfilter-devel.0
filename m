From: Matthias Andree <matthias.andree@gmx.de>
Subject: ip_conntrack_tcp_be_liberal vs. large downloads?
Date: Tue, 20 Sep 2005 10:08:25 +0200
Message-ID: <20050920080825.GA6536@merlin.emma.line.org>
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

I'm using a netfilter configuration that makes extensive use of
connection tracking, on Linux 2.6.8 and Linux 2.6.11.4 (SUSE Linux 9.2
and 9.3 kernels). Part of this configuration is to allow
ESTABLISHED+RELATED, drop INVALID and so on - pretty standard stuff as
found on various sites (I can dump the configuration if really needed).

My observation is that larger downloads (30 MB to 150 MB) stall after
some point, which may be sooner or later. I seldom get the download
beyond 15 or 20 MB, at transfer rates between 80 and 300 kB/s.  tcpdump
shows that the server (HTTP) still sends a few packages which the kernel
doesn't ACK any more.

Setting sysctl net.ipv4.netfilter.ip_conntrack_tcp_be_liberal=1 seems to
work around this. Older documentation appears to hint this switches the
treatment of out-of-window packets, ...be_liberal=0 treats all of them
invalid, ...be_liberal=1 only RST packets.

According to the documentation I'd found, it seems ...be_liberal=0 is
the way to go on firewalls, but if that breaks larger transfers, that's
no good.

Incidentally, all upstream servers I've observed this trouble with have
been running Microsoft IIS, namely download.fujitsu-siemens.com and
intel's "Premier" service download servers -- which makes matters worse
as IIS doesn't support ranges, so the download needs to start over,
rather than resume up where it stalled.

So I'm wondering

A) what the bug is

  - is the Windows TCP/IP stack on the server goofing up the sequencing
    or window scaling?

  - is the Linux stack under the HTTP client losing track, for instance,
    as numbers wrap, a certain time has elapsed since setup of connection?

  - can such happen as window sizes grow the longer transfers last

B) how to best debug this

I know tcpdump to some extent although I'm not really acquainted with
the sequence number and window tracking code, so directions will be
appreciated.

I can also test newer kernels if needed - only if there'd been some bug,
I might have assumed that SUSE rolled a patch into one of their update
kernels.

Thanks in advance.

-- 
Matthias Andree
