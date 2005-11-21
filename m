From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Mon, 21 Nov 2005 15:24:51 +0100
Message-ID: <4381D8B3.1010100@eurodev.net>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
	<Pine.LNX.4.64.0511172250390.9911@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511172250390.9911@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
>> I realised that Yasuyuki's patch is incomplete. Could you give a try to
>> the patch attached. Thanks.
> 
> Didn't help:
> 
>  ------------[ cut here ]------------
> kernel BUG at kernel/sched.c:2833!
> invalid operand: 0000 [#55]
> PREEMPT
> Modules linked in:

Did you install any extra module from pom-ng?

> CPU:    0
> EIP:    0060:[<c01166a5>]    Not tainted VLI
> EFLAGS: 00010206   (2.6.14.2)
> EIP is at sub_preempt_count+0x35/0x40
> 
> Need about 3 seconds to trigger this bug with:
> 
> # while true; do conntrack -L|wc -l; done

I can't reproduce that problem that you're reporting. I don't see how
the ctnetlink code can trigger that at the moment :(

The only bugfix that was in my pending queue is:
[PATCH] relax ip_conntrack_[nat_]proto_find_get checkings

-- 
Pablo
