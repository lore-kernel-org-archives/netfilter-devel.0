From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add TCPCONG target to patch-o-matic
Date: Thu, 12 Oct 2006 02:57:34 +0200
Message-ID: <452D92FE.7020707@trash.net>
References: <45235EDC.4080709@aarnet.edu.au>
	<4524118B.4020903@netfilter.org>	<4524BBB2.2000109@aarnet.edu.au>
	<452A66CA.70603@trash.net>	<452B4512.4070705@aarnet.edu.au>
	<452C81E2.1040206@trash.net> <20061011130413.6d44063f@freekitty>
	<452D8E30.5010909@aarnet.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Mailinglist <netfilter-devel@lists.netfilter.org>,
	Stephen Hemminger <shemminger@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Glen Turner <glen.turner@aarnet.edu.au>
In-Reply-To: <452D8E30.5010909@aarnet.edu.au>
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

Glen Turner wrote:
> Patrick, what's the easiest way to maintain this out of Netfilter?
> As a patch to patch-o-matic or as a direct patch to iptables and
> the kernel?

I depends on your workflow I guess. I personally prefer to keep
patches in git trees, for long-term maintenance patch-o-matic
might save you a bit of work by resolving Kconfig and Makefile
conflicts automatically. If you're going to set up an external
patch-o-matic repository we can add it to the distributed
sources.list if you want.
