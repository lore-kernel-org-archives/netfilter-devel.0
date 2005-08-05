From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Fri, 05 Aug 2005 12:43:04 +0200
Message-ID: <42F342B8.7010001@trash.net>
References: <42F2B507.8070207@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42F2B507.8070207@eurodev.net>
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
> This fixes the problem although I think that there's something wrong
> with current refcounting. Every time an expectation is created, the
> refcount of the master conntrack is incremented. Then, if the master
> conntrack is destroyed, say the timeout has expired,
> ip_ct_remove_expectation will be called. So firstly, all expectations
> linked to such conntrack are destroyed and then the conntrack itself.
> OK, my question is: why do we need to increase the master conntrack
> refcount for expectations, if they are always killed first? Actually I
> think that the master conntrack refcount should be increased once the
> expectation is confirmed but not in ip_conntrack_expect_alloc.

Only outstanding expectations are removed by remove_expectations().
The fullfilled ones need the reference for stuff like
ip_nat_follow_master.
