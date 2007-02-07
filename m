From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 03/15]: nf_conntrack_tcp: make sysctl variables
 static
Date: Wed, 07 Feb 2007 15:06:18 -0800 (PST)
Message-ID: <20070207.150618.130163894.davem@davemloft.net>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
	<20070207082236.27478.54256.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082236.27478.54256.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Wed,  7 Feb 2007 09:22:37 +0100 (MET)

> [NETFILTER]: nf_conntrack_tcp: make sysctl variables static
> 
> sysctls are registered by the protocol module itself since 2.6.19, no need
> to have them visible to others.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> ---
> commit 7d1ff8ef614415a0cad0eb9a357e614673ff5129
> tree 4281179ae6085fc97acf0431bb9719d35598c91f
> parent c37c212ee4396891fef4abdf856f97d024fca206
> author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:32 +0100
> committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:32 +0100
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)

Empty patch? :-)
