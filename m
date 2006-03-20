From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] futher {ip,ip6,arp}_tables unification
Date: Mon, 20 Mar 2006 15:37:05 +0100
Message-ID: <441EBE11.4090906@trash.net>
References: <200603171446.19856.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: dev@openvz.org, netfilter-devel@lists.netfilter.org,
	Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200603171446.19856.dim@openvz.org>
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

Dmitry Mishin wrote:
>  This patch moves {ip,ip6,arp}t_entry_{match,target} definitions to
>  x_tables.h. This move simplifies code and future compatibility fixes. 

Applied, thanks. I've fixed up the ipt action which didn't compile
anymore.
