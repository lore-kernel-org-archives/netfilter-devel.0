From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Add support of Boyer-Moore to the string match
Date: Thu, 25 Aug 2005 16:57:20 -0700 (PDT)
Message-ID: <20050825.165720.78015413.davem@davemloft.net>
References: <430E58F4.6090008@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <430E58F4.6090008@eurodev.net>
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

From: Pablo Neira <pablo@eurodev.net>
Date: Fri, 26 Aug 2005 01:49:08 +0200

> Davem has recently applied my patch to add support for Boyer-Moore 
> algorithm. So, the patch attached enables the use of it in the string 
> match for iptables that I submitted[1] some days ago.

I already made this change in my net-2.6.14 tree.
