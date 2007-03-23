From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/12]: Netfilter update part II
Date: Fri, 23 Mar 2007 11:24:13 -0700 (PDT)
Message-ID: <20070323.112413.25475823.davem@davemloft.net>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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
Date: Fri, 23 Mar 2007 15:04:58 +0100 (MET)

> Hi Dave,
> 
> these patches for 2.6.22 contain mostly cleanups: some nfnetlink_log cleanup
> and micro-optimizations, removal of changelogs in C files, conversion to use
> setup_timer in netfilter code and a size-reduction of struct nf_conntrack
> and struct sk_buff when connection tracking is disabled-
> 
> Please apply, thanks.

All applied, thanks a lot Patrick.
