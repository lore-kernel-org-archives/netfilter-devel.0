From: Patrick McHardy <kaber@trash.net>
Subject: Re: check timer active
Date: Wed, 08 Dec 2004 01:46:59 +0100
Message-ID: <41B64F03.1010206@trash.net>
References: <EINSTEINObLLAeSQzWA000068c7@einstein.systemmetrics.com>	<41B376E9.10607@eurodev.net>
	<41B37BE6.1090208@eurodev.net> <41B37E2F.4020007@trash.net>
	<41B38BC2.1030506@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41B38BC2.1030506@eurodev.net>
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

Pablo Neira wrote:

> arg, stupid me, such problem doesn't exist, if skb is NULL we don't 
> increase counters, that's what happens in amanda. Maybe the patch 
> attached could clean up the current API, anyway that's not a bugfix 
> anymore, so I'll hold it here.

As I said I don't want to apply cleanups to ip_conntrack currently,
at least until it's sorted out what happens to it. But I opened a
nf_conntrack tree and will add your cleanup to it once amanda is ported.

Regards
Patrick
