From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Sun, 20 Mar 2005 17:15:16 +0100
Message-ID: <423DA194.40100@trash.net>
References: <423BF227.8030502@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <423BF227.8030502@outerspace.dyndns.org>
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

Jonas Berlin wrote:
> Because include/linux/netfilter_ipv6/ip6t_REJECT.h was removed in 2.6.9, 
> the
> pom-ng module REJECT does not apply anymore. So this patch adds a 2.6.9
> branch which is identical to 2.6 except the .h file is added.
> 
> The empty patch file is there so that the original patch won't be 
> attempted.

Why add a new branch instead of simply restoring that file?
Even better, I think I'm simply going to submit the IPv6
REJECT target of nobody objects.

Regards
Patrick
