From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [IPTABLES PATCH] chain name should not start with '!'
Date: Fri, 03 Jun 2005 10:33:20 +0200
Message-ID: <42A015D0.8080300@eurodev.net>
References: <200506030803.j5383iXf006561@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200506030803.j5383iXf006561@toshiba.co.jp>
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

Hi Yasuyuki,

Yasuyuki KOZAKAI wrote:
> This patch fixes the bug allows to create the chain with name "!".
> 
> Regards,
> 
> -----------------------------------------------------------------
> Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
> 
> 
> ------------------------------------------------------------------------
> 
> Index: iptables.c
> ===================================================================
> --- iptables.c	(revision 3951)
> +++ iptables.c	(working copy)

please, could you send the same fix for ip6tables.c? it's got the same 
problem.

Thanks,
Pablo
