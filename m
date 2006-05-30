From: Cody Tubbs <tubbs@wispdirect.com>
Subject: ipv4options still broken (posted prev w/ no reply)...
Date: Tue, 30 May 2006 10:47:04 -0700
Message-ID: <1149011224.28886.14.camel@mbox>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

While we're on the nth match topic and speaking of broken modules in
pom, I posted a couple of weeks ago about the lsrr and ssrr options
being broken in the ipv4options module.  I had dialog with Fabrice, but
it seems he doesn't have time to maintain the module anymore, or at
least fix this issue.  It's giving everyone who is using it a false
sense of security, being that it loads, but doesn't do anything when an
lsrr/ssrr ip option is set and passes through the module.  Can this be
removed until it's fixed?  lsrr and ssrr are critical ip options to
monitor attempting to enter your network, and people using this module
thinking/expecting it to work can possibly get compromised via its lack
of mojo.  Thanks.

ps, testing with hping3 is a quick method to determine if changes
worked.
http://www.hping.org/download.html
(a simple command line tool that allows you to set lsrr/ssrr ip options,
among other things.)


-Cody Tubbs
