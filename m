From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Mon, 30 Apr 2007 01:06:15 +0200
Message-ID: <463524E7.60107@netfilter.org>
References: <20070428220206.GA26272@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070428220206.GA26272@linuxace.com>
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

Phil Oester wrote:
> In fixing bug #446 [1], the output for unspecified proto was changed
> from "all" to "0".  This reverts to the original behaviour, and
> closes bugzilla #543.

Applied a similar patch to ip6tables.c, thanks Phil. You're doing a nice
work closing open bugs in bugzilla.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
