From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: Add helper macro for xt_match
 boilerplate
Date: Thu, 30 Jul 2015 14:24:33 +0200
Message-ID: <20150730122433.GA5948@salvia>
References: <20150726115737.GA14070@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150726115737.GA14070@vaishali-Ideapad-Z570>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jul 26, 2015 at 05:27:37PM +0530, Vaishali Thakkar wrote:
> For simple modules that contain a single xt_match without any
> additional setup code then ends up being a block of duplicated
> boilerplate. This patch adds a new macro, module_xt_match(),
> which replaces the module_init()/module_exit() registrations with
> template functions.

I prefer not to use this macro, we may need to add something to the
module_init()/module_exit() path in the future to these netfilter
extensions and then we'll have to revert the follow up conversions
patches that you will likely send.

Thanks anyway.
