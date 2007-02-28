From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Notification of new/destroyed connection
Date: Wed, 28 Feb 2007 13:39:15 +0100
Message-ID: <45E577F3.1070003@netfilter.org>
References: <ba7529fb0702271449p460843fag8528aab89261ee84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Chris Taylor <chtaylo4@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <ba7529fb0702271449p460843fag8528aab89261ee84@mail.gmail.com>
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

Chris Taylor wrote:
> Then I saw the notification chains and I thought about makeing a
> notification block and registering it with
> nf_conntrack_register_notifier(struct notifier_block *nb).  I couldn't
> find the initial listing of the anticiapted values for the events and
> the void* p, but I saw examples in
> net/netfilter/nf_conntrack_netlink.c So I then turned my attention to
> include/linux/netfilter/nf_conntrack_common.h and saw the difference
> b/n ip_conntrack_expect_events and ip_conntrack_events, namely that
> ip_conntrack_expect_events only has IPEXP_NEW.

If you have to check for new and destroyed connections, just register a
module that listens to IPCT_NEW and IPCT_DESTROY events,
ip_conntrack_events in nf_conntrack_netlink is a good example. Forget
about ip_conntrack_expect_events since that functions handles
expectation events, AFAICS this is not what you want.

> Am I correct to assume that if I need to do some setup in advance of a
> connection establishment, then I should subscribe via the
> nf_conntrack_register_expect_notifier and wait for a IPEXP_NEW event?

No, this is for expectations. I suggest you to have a look at [1].

> What happenes if I do the setup and the connection is never
> established?  Will I get notified of that via the callback registered
> with nf_conntrack_register_notifier with a IPCT_DESTROY event?

Then the connection will expire after a certain timeout, no need to
worry about this scenario. You'll get IPCT_DESTROY anyway. You can tune
the timeout if you think that they are too long.

> Am I better off doing this with nf_conntrack or ip_conntrack?  What's
> the difference?

nf_conntrack is layer 3 independent, ip_conntrack is obsoleted and is
scheduled to be removed in 2.6.22 if my mind serves well. So go
nf_conntrack.

> Am I headed in the correct direction?

Basically yes.

[1] http://people.netfilter.org/pablo/docs/

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
