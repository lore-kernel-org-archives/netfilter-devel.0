From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 09/09]: futher {ip,ip6,arp}_tables unification
Date: Tue, 21 Mar 2006 03:11:46 +0100
Message-ID: <441F60E2.1070308@trash.net>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
	<20060321015604.11977.84327.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: dim@openvz.org, dev@openvz.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060321015604.11977.84327.sendpatchset@localhost.localdomain>
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
> [NETFILTER]: futher {ip,ip6,arp}_tables unification
> 
> This patch moves {ip,ip6,arp}t_entry_{match,target} definitions to
> x_tables.h. This move simplifies code and future compatibility fixes.

Dave, please drop this patch, I just noticed it breaks ip6tables
compatibility for some yet unknown reason. Sorry for not testing
it properly before.
