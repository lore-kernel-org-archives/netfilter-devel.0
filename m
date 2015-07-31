From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: Re: [PATCH] netfilter: xtables: Add helper macro for xt_match boilerplate
Date: Fri, 31 Jul 2015 07:33:20 +0530
Message-ID: <CAK-LDbLQXFtg7S6aQCJiTdt5VmTEx9MWEziD+VEkjKHBx+CL5g@mail.gmail.com>
References: <20150726115737.GA14070@vaishali-Ideapad-Z570>
	<20150730122433.GA5948@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150730122433.GA5948@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jul 30, 2015 at 5:54 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jul 26, 2015 at 05:27:37PM +0530, Vaishali Thakkar wrote:
>> For simple modules that contain a single xt_match without any
>> additional setup code then ends up being a block of duplicated
>> boilerplate. This patch adds a new macro, module_xt_match(),
>> which replaces the module_init()/module_exit() registrations with
>> template functions.
>
> I prefer not to use this macro, we may need to add something to the
> module_init()/module_exit() path in the future to these netfilter
> extensions and then we'll have to revert the follow up conversions
> patches that you will likely send.

Ok. This makes sense. I think in that case you can drop the patch.

Thank You.

> Thanks anyway.



-- 
Vaishali
