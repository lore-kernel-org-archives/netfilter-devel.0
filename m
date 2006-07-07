From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/10][CTNETLINK] dump counters iif connection ended or
 counters filled up
Date: Fri, 07 Jul 2006 06:48:58 +0200
Message-ID: <44ADE7BA.4030406@trash.net>
References: <44ADC3BD.3050609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44ADC3BD.3050609@netfilter.org>
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
> This patch makes ctnetlink to dump counters iif connection reaches the
> destroy state or altenatively if counters filled up.
> 
> AFAICS counters on NEW and UPDATE events doesn't provide interesting
> information, they just consume the limited netlink bandwidth.
> 
> Upcoming conntrackd release in statistics mode uses counters from
> DESTROY events to keep the contability of traffic that the firewall has
> processed.
> 
> I think that this patch should also reset counters upon fill up event,
> comments?

Not sure, do you know any users of the counters besides conntrackd?
I would like to look at how they're used.
