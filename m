From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] move ipt_error and ipt_standard to iptables.h
Date: Mon, 03 Jan 2005 00:03:03 +0100
Message-ID: <41D87DA7.7080203@trash.net>
References: <41D71E97.8020709@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41D71E97.8020709@eurodev.net>
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

> Hi,
>
> ipt_error_target, ipt_error and ipt_standard are defined in every 
> table. Move these declarations to ip_tables.h where I think they 
> really belongs to.
>
> Please, let me know if there any special reason to duplicate them that 
> way.

I can't imagine a reason, so I've applied you patch. Thanks.

Regards
Patrick
