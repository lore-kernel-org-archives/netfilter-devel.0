From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 02 Jul 2007 17:02:05 +0200
Message-ID: <4689136D.3090002@trash.net>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>		<4688F979.60606@trash.net>	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>
	<46891294.9030405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46891294.9030405@trash.net>
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

Patrick McHardy wrote:
> NICOLAS BOULIANE wrote:
> 
>>But even if I do:
>>  --every 4 --packet 2
>>The first time it will match the 3th packet
>>and all next time it will match the 4th packet, which I dont
>>understand why (technically yes, but philosophically not).
>>
>>Matching pattern look like:
>>1,2,(3),4,5,6,(7),8,9,10,(11),12,13,14,(15)
> 
> 
> 
> It starts at zero and goes up to n - 1. So for the second
> packet you would actually use --packet 1. A bit
> counterintuitive, I agree, but too late to change.


BTW, if this really bothers you, you could add a new option
for --packet (maybe --start) that subtracts one from the
starting point.
