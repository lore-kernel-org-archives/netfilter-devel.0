From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/10] updates for ctnetlink and conntrack core
Date: Fri, 07 Jul 2006 08:20:15 +0200
Message-ID: <44ADFD1F.7050602@trash.net>
References: <44ADC2EE.905@netfilter.org> <44ADED94.3010703@trash.net>
	<44ADF800.80701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44ADF800.80701@trash.net>
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
> In some very unscientific tests it showed a difference of about
> 4% when dumping everything compared to only diffs (measured
> with conntrack accounting enabled). Not something to easily
> throw away, but I bet we can easily increase the netlink bandwidth
> for ctnetlink by using more reasonable allocation size and
> avoiding the netlink_trim call for every single packet.

Some more unscientific tests: saving the netlink_trim call by using
an allocation size of 200 reduces overhead for the entire notification
function (including broadcasting) by about 13% (and also reduces
the overruns experienced by conntrack -E for ~390000 packets with
65536 new connections from 17 to 7, which I don't really understand
since it shouldn't save any netlink bandwidth and this is a SMP system).
