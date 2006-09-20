From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 05/39]: ipt_TCPMSS: remove impossible condition
Date: Wed, 20 Sep 2006 13:27:18 +0200
Message-ID: <45112596.9040705@trash.net>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>	<20060920082449.14636.26271.sendpatchset@localhost.localdomain>
	<45112107.4020905@drugphish.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net, w@1wt.eu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <45112107.4020905@drugphish.ch>
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

Roberto Nibali wrote:
> Could be a candidate for 2.4 kernels as well. Although, it's not a
> strict bugfix, only a performance improvement, at best.

No, both are definitely not 2.4 candidates. I only pass on bugfixes
for bugs that were also reported by 2.4 users and security fixes.
