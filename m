From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Fri, 05 Aug 2005 12:21:00 +0200
Message-ID: <42F33D8C.5070904@trash.net>
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
> This patch comes from the following thread:
> 
> [PATCH 6/7] Fix expectation creation
> 
> In unlink_expect, the expectation is removed from the list so the
> refcount must be dropped as well.

The patch is fine, but it leaves the somewhat broken function
__ip_ct_expect_unlink_destroy around. I'm not sure what the
intention of this function is, it looks like a lazy way of
killing conntracks without manually dropping the timer refcnt.
Anyway it invites people to use it in the wrong place and
should die IMO.
