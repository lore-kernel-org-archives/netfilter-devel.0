From: William Stearns <wstearns@pobox.com>
Subject: patch-o-matic-ng 20040213, string match fixes
Date: Sat, 14 Feb 2004 15:12:38 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402141429460.11935-100000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Emmanuel Roger <winfield@freegates.be>,
   Gianni Tedesco <gianni@scaramanga.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, all,
	In the string match, the first line of 
string/linux/net/ipv4/netfilter/Makefile.ladd needs to be changed from its 
current:

obj-$(CONFIG_IP_NF_MATCH_UNCLEAN) += ipt_UNCLEAN.o

	to, say,

obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o

	Secondly, the ipt_string.c file does not compile under 2.6 kernels 
because of the (no longer defined smp_num_cpus).  I spent some more time 
on Google and still can't find the right fix for this; the only thing that 
gets it to compile is 

int smp_num_cpus = 1;

	at the top of the file, and I know that's absolutely not correct.
	Cheers,
	- Bill

---------------------------------------------------------------------------
	"Outside of a dog, a book is a man's best friend.  Inside a dog
it's too dark to read."
	-- Groucho Marx
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
--------------------------------------------------------------------------
