From: "Chris Taylor" <chtaylo4@gmail.com>
Subject: Notification of new/destroyed connection
Date: Tue, 27 Feb 2007 17:49:04 -0500
Message-ID: <ba7529fb0702271449p460843fag8528aab89261ee84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello all,

Newbie warning!!  I was trying to fool around with netfilter and
nf_conntrack.  I'd like to write a netfilter module that takes action
when a new connection is opened or closed.

Initially I thought about taking the sk_buff and pass it to
nf_ct_get_tuple and then call nf_conntrack_find_get and if it returns
null then I it's a new connection.  But I can't find a way to use this
to see if a connection has been closed.

Then I saw the notification chains and I thought about makeing a
notification block and registering it with
nf_conntrack_register_notifier(struct notifier_block *nb).  I couldn't
find the initial listing of the anticiapted values for the events and
the void* p, but I saw examples in
net/netfilter/nf_conntrack_netlink.c So I then turned my attention to
include/linux/netfilter/nf_conntrack_common.h and saw the difference
b/n ip_conntrack_expect_events and ip_conntrack_events, namely that
ip_conntrack_expect_events only has IPEXP_NEW.

Am I correct to assume that if I need to do some setup in advance of a
connection establishment, then I should subscribe via the
nf_conntrack_register_expect_notifier and wait for a IPEXP_NEW event?
What happenes if I do the setup and the connection is never
established?  Will I get notified of that via the callback registered
with nf_conntrack_register_notifier with a IPCT_DESTROY event?

Am I better off doing this with nf_conntrack or ip_conntrack?  What's
the difference?

Am I headed in the correct direction?

Thanx in advance.

Respectfully,
Christopher Taylor
