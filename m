From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problems with libnetfilter_conntrack / cntl_test
Date: Wed, 16 Nov 2005 16:44:41 +0100
Message-ID: <437B53E9.2080800@eurodev.net>
References: <200511161439.04498.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
In-Reply-To: <200511161439.04498.pluto@agmk.net>
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

Pawel Sikora wrote:
> I have installed a 2.6.14.2 kernel + grsecurity-2.1.7-2.6.14.2-$latest,
> libnfnetlink-0.0.13 and libnetfilter_conntrack-0.0.28.
> 
> ./ctnl_test fails:
> 
> Test for libnetfilter_conntrack
> 
> NFNETLINK answers: Invalid argument
> TEST 1: create conntrack (-22)
> TEST 2: dump conntrack table and reset (-22)
> TEST 3: dump conntrack table (-22)
> TEST 4: get conntrack (-22)
> TEST 5: update conntrack (-22)
> NFNETLINK answers: Invalid argument
> TEST 6: delete conntrack (-22)
> nfnl_open: bind(netlink): Operation not permitted
> Can't open handler
> Test failed with error -2. Errors=7
> 
> Is this a grsec issue?

Hard to say, my last contact with grsec was years ago. That output is
kind of weird. Could you try reverting the grsec patch?

> socket(PF_NETLINK, SOCK_RAW, 12)        = 3
> bind(3, {sa_family=AF_NETLINK, pid=0, groups=00000007}, 12) = -1 EPERM (Operation not permitted)
> write(2, "nfnl_open: bind(netlink): Operat"..., 50nfnl_open: bind(netlink): Operation not permitted
> ) = 50

This line tells me that you are not executing ctnl_test as root.

-- 
Pablo
