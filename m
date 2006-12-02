From: David Miller <davem@davemloft.net>
Subject: Re: libipt_multiport: getsockopt failed strangely: Invalid argument
Date: Fri, 01 Dec 2006 20:15:26 -0800 (PST)
Message-ID: <20061201.201526.35798692.davem@davemloft.net>
References: <45705747.9090806@trash.net>
	<20061201.152406.32722891.davem@davemloft.net>
	<4570BFF8.4060107@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: arnaud@andesi.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4570BFF8.4060107@trash.net>
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
Date: Sat, 02 Dec 2006 00:51:20 +0100

> Its already in 2.6.19, but I didn't expect it to really fix
> something. I've attached it again, it applies all the way
> back to 2.6.17 when the compat code was introduced.

Pushed to -stable, thanks Patrick.
