From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Devel] [PATCH] futher {ip,ip6,arp}_tables unification
Date: Mon, 20 Mar 2006 15:39:22 +0100
Message-ID: <441EBE9A.7090106@trash.net>
References: <200603171446.19856.dim@openvz.org>
	<200603171902.34281.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: dev@openvz.org, netfilter-devel@lists.netfilter.org,
	Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>, devel@openvz.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
In-Reply-To: <200603171902.34281.dim@openvz.org>
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
> Forgot required tc_ipt.h modification. Corrected.

Missed this mail. Your patch is better, so I backed out my version
and took this one instead.
