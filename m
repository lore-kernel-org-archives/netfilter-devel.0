From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 03/15]: nf_conntrack_tcp: make sysctl variables
	static
Date: Thu, 08 Feb 2007 00:09:24 +0100
Message-ID: <45CA5C24.4040600@trash.net>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>	<20070207082236.27478.54256.sendpatchset@localhost.localdomain>
	<20070207.150618.130163894.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207.150618.130163894.davem@davemloft.net>
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

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Wed,  7 Feb 2007 09:22:37 +0100 (MET)
> 
> 
>>[NETFILTER]: nf_conntrack_tcp: make sysctl variables static
>>
>>sysctls are registered by the protocol module itself since 2.6.19, no need
>>to have them visible to others.
>>
>>Signed-off-by: Patrick McHardy <kaber@trash.net>
>>
>>---
>>commit 7d1ff8ef614415a0cad0eb9a357e614673ff5129
>>tree 4281179ae6085fc97acf0431bb9719d35598c91f
>>parent c37c212ee4396891fef4abdf856f97d024fca206
>>author Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:32 +0100
>>committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:37:32 +0100
>>
>> 0 files changed, 0 insertions(+), 0 deletions(-)
> 
> 
> Empty patch? :-)

Oops, sorry :) I started using stgit some time ago, but I still
sometimes forget to refresh the patches. I'll resend tomorrow,
please just drop everything.
