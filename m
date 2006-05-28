From: Patrick McHardy <kaber@trash.net>
Subject: Re: Query: status of ipt_recent?
Date: Sun, 28 May 2006 14:05:11 +0200
Message-ID: <447991F7.6030808@trash.net>
References: <45ai725cka9svjijcg1qnbm5fcd90uq4c1@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grant Coady <gcoady.lk@gmail.com>
In-Reply-To: <45ai725cka9svjijcg1qnbm5fcd90uq4c1@4ax.com>
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

Grant Coady wrote:
> Hi there,
> 
> Recently there was query on lkml about ipt_recent, that a patch 
> for a memory leak may not going far enough.  What is status on 
> ipt_recent and is anyone backporting the new version to 2.4 kernel?

The problem with the recent match is mostly that its an offence
to the eyes and very hard to maintain, even small and simple patches
are hard to review. As far as I know it works fine if you forget
about a few corner cases, so I don't really see a reason for a
backport. Shouldn't be very hard though.
