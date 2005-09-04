From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes: wrong depends on Kconfig
Date: Sun, 04 Sep 2005 18:00:36 +0200
Message-ID: <431B1A24.4000304@trash.net>
References: <1125808606.32363.1.camel@ceci.ws.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Diego Woitasen <diegows@linux.org.ar>
In-Reply-To: <1125808606.32363.1.camel@ceci.ws.ar>
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

Diego Woitasen wrote:
> depends on IP_NF_CONNTRACK_ACCT && IP_NF_IPTABLES
> 
> sould be replaced by
> 
> depends on IP_NF_CT_ACCT && IP_NF_IPTABLES
> 
> The first is not working in new kernels.

The current tree already include the connbytes match and the
correct dependency:

config IP_NF_MATCH_CONNBYTES
         tristate  'Connection byte/packet counter match support'
         depends on IP_NF_CT_ACCT && IP_NF_IPTABLES
