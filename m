From: Eric Leblond <eleblond@inl.fr>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Sun, 31 Jul 2005 11:29:53 +0200
Message-ID: <1122802193.4159.12.camel@porky>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050731080143.GA10374@rama.de.gnumonks.org>
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

On Sun, 2005-07-31 at 10:01 +0200, Harald Welte wrote:
> Hi!
> 
> The areas of most work are currently nfnetlink, nfnetlink_log,
> nfnetlink_queue and ip_conntrack_netlink (previously called ctnetlink).
> Work in the kernel should be mostly finished, but the respective
> userspace counterparts definitely need some work.

I'm writing you as one of the NuFW developers. As you may know this
project do an intensive use of ip_queue. So, we are really interested in
userspace counterparts. In particular, our center of interest is
libnfnetlink_queue. I will do some test in the coming days to check if
NuFW is working with NFQUEUE.

> I've put together a quick TODO list at 
> 	http://people.netfilter.org/laforge/TODO

I will start from point one of libnfnetlink_queue and let you know.


I also have got one related question :
Is the userspace marking enable in NFQUEUE ?

Thanks for the work ! I can not wait to see a snort-inline, NuFW
firewall.

BR,
-- 
Eric Leblond <eric@regit.org>
NuFW, Now User Filtering Works : http://www.nufw.org
