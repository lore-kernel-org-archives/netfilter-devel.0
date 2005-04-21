From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Fri, 22 Apr 2005 01:01:19 +0200
Message-ID: <426830BF.7020107@trash.net>
References: <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>	<20050406044806.GA9711@linuxace.com>
	<4263108E.1030707@trash.net>	<20050419005847.GA591@linuxace.com>
	<42666F4C.5080706@trash.net>	<20050420155308.GA7057@linuxace.com>
	<42667E51.3060005@trash.net>	<20050420172406.GB7057@linuxace.com>
	<42669674.3020905@trash.net>	<20050420182505.GA7612@linuxace.com>
	<4267042A.2090906@trash.net>
	<4267AB2A.9050604@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <4267AB2A.9050604@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> Would there be something to lose in using INT_MAX/2 (or something)
> instead of INT_MAX as a base for the additions? And/or maybe have a bit
> of space between them in case something new pops up later? Of course you
> _can_ change them later, but there's always the risk that some 3rd party
> software out there basing themselves on a standard kernel including
> these additions, so I think it would be nice not to have to change them
> later..

These hooks should be last. If anyone has a valid reason to call
something after them they can post their code to the list and
we can change it.

Regards
Patrick
