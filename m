From: Ivan Mitev <imitev@obs.bg>
Subject: status of ipsec patches with >=2.6.8
Date: Sat, 11 Sep 2004 17:24:22 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040911152422.GC28465@obs.bg>
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

hi all

a few weeks back, i tested quite deeply the new 2.6 ipsec stack along with netfilter and patrick's pom-ng ipsec patches, and i didn't encounter any big problem.

now that i want to make the switch from test to pre-production, i don't manage to patch iptables/kernel anymore with a 2.6.8.1 kernel; i tested with both stable and CVS versions of pom-ng and iptables ; (and i really need a kernel >= 2.6.7-mm2 because of hugeTLB stuff and new 3ware drivers).

any idea about the status of recent kernels ? (on harald's blog, i see that there is some work on it, but no indication of success - Thu, 22 Jul 2004). any pointer ?

another question for the maintainers, more with politics: do you plan to try to merge the ipsec patches into the mainline kernel (especialy with the patches modifying the way packets hit the hooks ) ? or are they condamned to stay in pom-ng's extras ?

in other words, do you plan that most of the "ipsec people" will use these patches, or are they provided for convenience, with the majority of people using the current - strange - ipsec packet travelling.

sorry for these rather stupid questions, but i couldn't find a clue browsing the lists, and there's not a lot of feedback for the ipsec patches.  since i'm building a quite complex "advanced router" suitable for many of our firewalls, i'm feared to spend a consequent amount of time on something that might be deprecated soon.

thanx !
ivan
