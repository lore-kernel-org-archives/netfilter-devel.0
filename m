From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/10] updates for ctnetlink and conntrack core
Date: Wed, 19 Jul 2006 18:39:08 +0200
Message-ID: <44BE602C.9070800@trash.net>
References: <44ADC2EE.905@netfilter.org>	<44ADED94.3010703@trash.net>	<44ADF800.80701@trash.net>	<44ADFD1F.7050602@trash.net>	<44AE65C0.8030209@netfilter.org>	<44B1DACC.5030309@trash.net>
	<44B6A67F.70102@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44B6A67F.70102@netfilter.org>
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
> So, to keep consistency with other netlink subsystem, I can remake my
> patch based on this assumptions:
> 
> - NEW events dump everything but values that are unset like counters,
> mark, ...
> - UPDATE events dump everything but unset fields and the counters, they
> don't provide very useful information AFAICS.
> - DESTROY, dump everything, counters included.
> 
> Please let me know what you think.

That sounds good, but I don't think DESTROY needs to dump more than
NEW or UPDATE.
