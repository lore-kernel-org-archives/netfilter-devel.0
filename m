From: Peteris Krumins <newsgroups@lf.lv>
Subject: Still problems w/ ip_conntrack as module
Date: Fri, 5 Sep 2003 23:53:20 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <179356969284.20030905235320@lf.lv>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  A year ago i run into a problem w/ unloading ip_conntrack
  module. The symptomus were the following:
   If ip-connrack reached more than a few thousand entries,
   after trying to unload it, the rmmod process would
   simply go into a tight loop, getting up to full
   cpu usage, killing wouldnt help, only a reboot.
   
   That time i solved the problem by compiling
   ip_conntrack into the kernel and forgetting about
   the problem

 Now again, i upgraded the machine to 2.4.21-pre6
 (last known stable from 2.4.x tree for my needs imo),
 the problem is there again. This time i cant
 solve it by compiling the module into the kernel
 and forgetting it, as the software developed
 by my programmer team relies on loading
 and unloading the module (sometimes (just to
 clear conntrack table)).

 Any comments?


P.Krumins
