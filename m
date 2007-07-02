From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 02 Jul 2007 19:40:10 +0200
Message-ID: <4689387A.4050207@trash.net>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>	
	<4688F979.60606@trash.net>	
	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>	
	<46891294.9030405@trash.net>
	<dd45289d0707021038p42e1871n200d2c425d50797c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0707021038p42e1871n200d2c425d50797c@mail.gmail.com>
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
> On 7/2/07, Patrick McHardy <kaber@trash.net> wrote:
>
>> It starts at zero and goes up to n - 1. So for the second
>> packet you would actually use --packet 1. A bit
>> counterintuitive, I agree, but too late to change.
>
> with --every 4 --packet 2
> [ count = every - packet ]
>
> in the final check:
> count = 1
> every = 3
> packet = 2
>
> I don't see what is starting at zero.

The count. --packet n will match the n+1th packet.
