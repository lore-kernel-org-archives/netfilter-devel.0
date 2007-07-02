From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 02 Jul 2007 20:16:54 +0200
Message-ID: <46894116.9000203@trash.net>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>	
	<4688F979.60606@trash.net>	
	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>	
	<46891294.9030405@trash.net>	
	<dd45289d0707021038p42e1871n200d2c425d50797c@mail.gmail.com>	
	<4689387A.4050207@trash.net>
	<dd45289d0707021105q6b70c23m45135e0a56ccb5aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0707021105q6b70c23m45135e0a56ccb5aa@mail.gmail.com>
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

NICOLAS BOULIANE wrote:
> i'm not trying to bother you, but there's surely something I dont
> understand.


Don't worry :)

> In the kernel we have:
>   if (info->u.nth.count++ == info->u.nth.every)
>    info->u.nth.count = 0;
> 
> --every 4 --packet 2
> count = 1, every = 3, packet = 2
> 
> 1th packet:
>           if (1 == 3) { // no match
> 
> 2th packet:
>           if (2 == 3) { // no match
> 
> 3th packet:
>            if (3 == 3) { // match and set __count = 0__
> 
> next time we will match the 4th packet.
> Is what I should expect ? or there's something wrong.


It is. "--every 4" is the period, we'll match every 4th packet.
"--packet 2" says you want to match the third (thats the
non-obvious part) packet.

The main reason why you would --packet at all is for multiple
subsequent rules that don't abort rule traversal:

... --every 4 --packet 0 -j MARK --set-mark 1	(match 1st packet)
... --every 4 --packet 1 -j MARK --set-mark 2	(match 2nd packet)
... --every 4 --packet 2 -j MARK --set-mark 3	(match 3rd packet)
... --every 4 --packet 3 -j MARK --set-mark 4	(match 4th packet)

So for every packet only a single rule will match. You could do
something like that for load-balancing for example.
