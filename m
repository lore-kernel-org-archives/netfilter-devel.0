From: William Stearns <wstearns@pobox.com>
Subject: Thumbs up for POM-NG, incorrect fix for ipt_string.c
Date: Sat, 7 Feb 2004 14:19:14 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402071412270.27286-100000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>, Gianni Tedesco <gianni@ecsc.co.uk>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, Harald, Gianni,
	First off, _nice work_on patch-o-matic-ng, Harald - it worked
almost flawlessly right out of the box.  pom-ng-20040206 put in almost
every module correctly, although I had to manually add ipt_string, I
suspect because Makefile.ladd was looking for an ipt_unclean line and 2.6
doesn't have it.
	ipt_string.c didn't compile correctly out of the box, because of a 
missing symbol smp_num_cpus.  I know there's a _correct_ fix for that 
(something like NR_CPUS?), but I couldn't find it.  Adding the line

int smp_num_cpus = 1;

	near the top of that file allowed it to compile and link correctly 
on my UP box, but I hold _no_ illusions that this is correct!
	Cheers,
	- Bill

---------------------------------------------------------------------------
	"Perfection is reached, not when there is no longer anything to
add, but when there is no longer anything to take away."
	-- Antoine de Saint-Exupery
(Courtesy of Thomas Graichen <tgr@spoiled.org>)
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
--------------------------------------------------------------------------
