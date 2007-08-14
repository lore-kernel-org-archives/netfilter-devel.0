From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][CTNETLINK] Include the id in conntrack netlink events.
Date: Tue, 14 Aug 2007 08:01:00 +0200
Message-ID: <46C1451C.5040107@trash.net>
References: <46C138AC.1000106@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46C138AC.1000106@snapgear.com>
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

Philip Craig wrote:
> I need the id in ctnetlink events for my application, so here's a
> patch to add it in case this wasn't left out intentionally.
>   

It was, we have plans to remove it. What for do you need it
exactly?
