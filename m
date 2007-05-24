From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] H.323: update ASN.1 types
Date: Thu, 24 May 2007 20:48:53 +0200
Message-ID: <4655DE15.9080906@trash.net>
References: <20070517191756.728953DA1F7@jzhao.vivecode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@vivecode.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070517191756.728953DA1F7@jzhao.vivecode.com>
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
> nf_conntrack_h323_types.h and nf_conntrack_h323_types.c have been updated.
> 
> 1. Add support for decoding IPv6 address. I know it was manually added in the header file, but not in the template file. That wouldn't work.
> 2. Add missing support for decoding T.120 address in OLCA.
> 3. Remove unnecessary decoding of Information signal.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>


Applied, thanks a lot.
