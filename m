From: Eric Leblond <eric@inl.fr>
Subject: ip_queue freeze with 2.6.9 RHEL4
Date: Wed, 20 Jul 2005 22:35:48 +0200
Message-ID: <1121891748.16195.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: redhat-list@redhat.com
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

Hi,

I've found a reproductible kernel freeze on RHEL 4.

The method is the following. I use nufw 1.0.10 (http://www.nufw.org/) to
send an accept decision to ip_queue (Same nufw version works well on all
other systems). This is enough to freeze the computer in most cases. If
the freeze has not occured, then nufw process is a zombie. We can then
achieve a freeze by doing rmmod ip_queue.

I've tested redhat provided kernels 2.6.9-5 and 2.6.9-11 (SMP or not).
Servers are bi Xeon based computer, working well and already used by
other people for intensive testing on non-firewall tasks.

Is there known issues on some systems with 2.6.9 and ip_queue ? or is it
a RedHat problem ?

As I've used home build 2.6.9 with nufw quiet a long time on other
systems without problem, I think it could be related to RedHat
modifications of the kernel.

BR,
-- 
Eric Leblond <eric@inl.fr>
