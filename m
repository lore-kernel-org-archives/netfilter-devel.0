From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 2 Jul 2007 12:38:53 -0500
Message-ID: <dd45289d0707021038p42e1871n200d2c425d50797c@mail.gmail.com>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>
	<4688F979.60606@trash.net>
	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>
	<46891294.9030405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46891294.9030405@trash.net>
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

On 7/2/07, Patrick McHardy <kaber@trash.net> wrote:

> It starts at zero and goes up to n - 1. So for the second
> packet you would actually use --packet 1. A bit
> counterintuitive, I agree, but too late to change.

with --every 4 --packet 2
[ count = every - packet ]

in the final check:
count = 1
every = 3
packet = 2

I don't see what is starting at zero.

--
acidfu
