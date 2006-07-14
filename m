From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnfnetlink 0.0.16 and missing types
Date: Fri, 14 Jul 2006 16:19:15 +0200
Message-ID: <44B7A7E3.1030603@netfilter.org>
References: <Pine.LNX.4.64.0607131821350.3308@pvaqre.alien.bet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Felipe Kellermann <stdfk@terra.com.br>
In-Reply-To: <Pine.LNX.4.64.0607131821350.3308@pvaqre.alien.bet>
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

Felipe Kellermann wrote:
> Using 2.6.17.1, GCC 4.1.1. libnfnetlink isn't compiling correctly.
> 
> libnfnetlink.c includes linux/netlink.h, which uses undefined typedefs 
> because neither libnfnetlink.c nor linux/netlink.h includes linux/types.h.
> 
> Am just wondering if there is a rationale about the correct place to put 
> this type of include (types.h). IMHO it would have to be placed in every 
> type of header which uses types defined in linux/types.h. The include safe 
> guards would do the job about the multiple inclusions.
> 
> So the simpler (and not exactly correct IMHO) fix is attached (used in the 
> Fedora Core package now). The more general and correct fix would be to add 
> includes in the headers using the types and not including it.
> 
> For instance, to investigate the number of users of __u32 which does not 
> include -- at least directly -- linux/types.h, I did this searching:

Thanks Felipe, but we already have a patch for this in SVN.

http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3651

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
