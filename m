From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes & 64bit counters
Date: Thu, 26 Oct 2006 00:20:21 +0200
Message-ID: <453FE325.1040502@trash.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Hello,
> 
> It seems there is something wrong with connbytes and 64bit conters.
> 
> The "iptables" manual mention that counters are 64bit, so there should
> be no problem with overflows, but it seems it might not be true. My
> firewall puts long living ftp & http connections to a different TC class
> when they reach 256MB, but aftear they reach 4GB (probably) they go back
> to the default class, with no speed limit.
> 
> After some researches I found that ip_conntrack_counter structure
> defined in nf_conntrack_common.h uses u_int32_t. I always thought that
> netfilter has 64bit counters, hasn't it? And I'm quite sure it used to
> work when I set up my firewall, about 1 year ago. Stange...


It was changed to save some memory in struct ip_conntrack.
The idea was mainly that its only used for ctnetlink and
it is possible to send events before overflow. Obviously,
this wasn't true (besides the fact that events are unreliable).
Not sure what we should do about it ..
