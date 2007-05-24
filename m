From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] H.323: update get_h225_addr() for IPv6 address
	access
Date: Thu, 24 May 2007 20:52:22 +0200
Message-ID: <4655DEE6.8030805@trash.net>
References: <20070517191756.A7F5F3DA1F9@jzhao.vivecode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@vivecode.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070517191756.A7F5F3DA1F9@jzhao.vivecode.com>
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

Jing Min Zhao wrote:
> Update get_h225_addr() to meet the changes in ASN.1 types. It was using field ip6 to access IPv6 TransportAddress, it should be ip according the ASN.1 definition.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>


Also applied, thanks.

BTW, I've replaced "update" by "fix" in the patch title since these
really are fixes and the merge window is already closed.
