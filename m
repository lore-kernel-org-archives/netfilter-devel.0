From: pud <pud@safetpin.homeunix.org>
Subject: kernel panic with ctnetlink/nfnetlink
Date: Wed, 15 Jun 2005 18:40:34 +0200
Message-ID: <20050615164034.GA15168@safetpin.homeunix.org>
Reply-To: pud@subnet666.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

hey,

when i apply conntrack-event-api/ctnetlink/nfnetlink-
(i wanted to try the userspace conntrack tool)
patches from recent svn, i always get a kernel panic
after 1-4 hours in process swapper
call trace says, that ip_finish_output2 is called, then
swapper, and again...
don't know, maybe somebody knows why this causes a panic...

cu,
=;p)ud

-- 
pgp-key at https://safeTpin.homeunix.org/pud.asc
