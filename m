From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] use C99 structure initialization in nat helpers
Date: Mon, 07 Mar 2005 00:12:06 +0100
Message-ID: <422B8E46.30908@trash.net>
References: <422B8716.9010804@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <422B8716.9010804@eurodev.net>
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
> This patch makes nat helpers use c99 structure initialization. It 
> applies on top of the previous patch.

Thanks, but it doesn't apply without the previous patch. Hint: Send
cleanups first in a series of patches :)

Regards
Patrick
