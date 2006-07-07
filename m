From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/10] updates for ctnetlink and conntrack core
Date: Fri, 07 Jul 2006 07:13:56 +0200
Message-ID: <44ADED94.3010703@trash.net>
References: <44ADC2EE.905@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44ADC2EE.905@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Hi,
> 
> Here follows a set of patches for ctnetlink and the conntrack core API.

I'm perfectly fine with 1, 2, and 9. Still need to look at 10 in
more detail, 3 - 5 need a bit more work. As for 6 - 8, see below.

> Basically, at the time that I was working on the ctnetlink patches, I
> tried to keep in mind the idea of reducing the netlink bandwidth
> consumption following the principle of just dumping meaningful fields
> depending on the type of event.
> 
> Please let me know what you think. Thanks!

I think this is something we need to agree on in principle. I'm
not convinced that we really do save much bandwidth in the
common case, and that its worth diverging from the usual update
notifications containing full updates sent by the remaining
network stack (besides unset fields or fields containing 0).

I'll see if I can get some numbers of the actual differences
without too much effort.
