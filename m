From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 02 Jul 2007 16:58:28 +0200
Message-ID: <46891294.9030405@trash.net>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>	
	<4688F979.60606@trash.net>
	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>
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

[Don't remove CCs please]

NICOLAS BOULIANE wrote:
> Hi Patrick,
> 
> First, there's no upper bound check to ensure that `--packet` value is n-1,
> so I'm confused.
> 
> if (string_to_number(optarg, 0, 0xFFFFFFFF,
>                         &info->u.nth.packet) == -1)


Yes, that should be fixed.

> 
> But even if I do:
>   --every 4 --packet 2
> The first time it will match the 3th packet
> and all next time it will match the 4th packet, which I dont
> understand why (technically yes, but philosophically not).
> 
> Matching pattern look like:
> 1,2,(3),4,5,6,(7),8,9,10,(11),12,13,14,(15)


It starts at zero and goes up to n - 1. So for the second
packet you would actually use --packet 1. A bit
counterintuitive, I agree, but too late to change.
