From: Yoshioka Tsuneo <tsuneo.yoshioka@f-secure.com>
Subject: Re: [tproxy] Re: Request: including tproxy patch to official
	iptables/kernel.
Date: Wed, 18 Oct 2006 01:17:55 +0900
Message-ID: <20061018010325.F515.TSUNEO.YOSHIOKA@f-secure.com>
References: <45331D32.5070209@trash.net> <200610171638.25425@nienna>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	tproxy@lists.balabit.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <200610171638.25425@nienna>
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

Hello KOVACS Krisztian

>   Yes, there was significant progress since then, we're testing the 
> patches at the moment. There still are a couple of problems with the new 
> approach, but it certainly looks promising. I'll post the patches on 
> netfilter-devel for review and comments as soon as things have settled 
> down a bit.
Thank you for your planning to new tproxy version. I'm looking forward
to the new version !

>   Moreover, I think there's no general consensus between networking 
> maintainers whether or not the features tproxy provides are worth the 
> hassles. Transparent proxying features have been removed during the 2.3 
> development as there seemed little interest in those. Of course there are 
> a handful of companies interested in having the feature in mainline, but 
> let's face the facts: the majority of users do not care about tproxy. 
> That's why I don't even try to get it merged.
I think that this is not so minor request.
At long as I heard, most of transparent-proxy user want to keep source
IP address, if possible.
Changing source IP address prevent IP address based access control or
make it difficult to analize log files, or tracing.
Some of appliance server can keep source IP addresses, but I think that it
is better that normal kernel user can use this feature without difficulty,
too.

Thank you !

-- 
Nihon F-Secure Corporation
(Yoshioka Tsuneo)
E-MAIL: Tsuneo.Yoshioka@f-secure.com

> 
>   Hi,
> 
> On Monday 16 October 2006 07:48, Patrick McHardy wrote:
> > > So, I would like to suggest to include tproxy patch to official
> > > iptables/kernel release.
> >
> > These look quite old (2.4). The TPROXY developers were working on
> > a new approach last year at the netfilter workshop, but I don't
> > know if there was any further progress. Please talk to them directly
> > and ask them if they want to merge it upstream, and if so to submit
> > patches.
> 
>   Yes, there was significant progress since then, we're testing the 
> patches at the moment. There still are a couple of problems with the new 
> approach, but it certainly looks promising. I'll post the patches on 
> netfilter-devel for review and comments as soon as things have settled 
> down a bit.
> 
>   Instead of trying to get the 2.0 branch of tproxy merged into mainline 
> we're concentrating our efforts on getting the new code working. As the 
> maintainer of the current tproxy patchset, I do not consider it clean and 
> safe enough to have it merged upstream.
> 
>   Moreover, I think there's no general consensus between networking 
> maintainers whether or not the features tproxy provides are worth the 
> hassles. Transparent proxying features have been removed during the 2.3 
> development as there seemed little interest in those. Of course there are 
> a handful of companies interested in having the feature in mainline, but 
> let's face the facts: the majority of users do not care about tproxy. 
> That's why I don't even try to get it merged.
> 
> -- 
>  Regards,
>   Krisztian Kovacs
> _______________________________________________
> tproxy mailing list
> tproxy@lists.balabit.hu
> https://lists.balabit.hu/mailman/listinfo/tproxy
