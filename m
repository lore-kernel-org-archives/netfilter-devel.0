From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Sat, 29 Apr 2006 04:56:08 +0200
Message-ID: <4452D5C8.6020007@trash.net>
References: <200604201919.19246.max@nucleus.it> <200604281718.16912@nienna>
	<445235FE.9040203@trash.net> <200604290253.49758.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604290253.49758.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Friday 28 April 2006 5:34 pm, Patrick McHardy wrote:
> 
> 
>>Hehe :) Yes, its not nice, but I refuse to add stupid limits just
>>because the infrastructure can't cleanly support per-instance state
>>(which is what makes it ugly, its not the shared state). And its not
>>so bad, the uglyness comes down to two or three extra lines of code,
>>one additional pointer in the data structure and one offsetof in
>>userspace.
> 
> 
> Nontheless, I think modifying userspace because 2 kernel functions can't talk 
> to each other is a bit silly.
> It would be relatively easy to modify the kernel in order to support instance 
> data (extensive, but simple and relatively safe).
> Do you think there would be a strong resistance to a patch in mainline kernel?

It is silly, but we have to live with it. I see two possibilities, one
breaks userspace, one is extremly expensive. I like neither one.
We should just add a clean netlink configuration interface modelled
after the existing ones instead of building workarounds in this
clearly broken interface. I mostly don't care about costs of a
compatibility layer if we get a sane infrastructure in return.
