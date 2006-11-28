From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2]: conntrack: fix refcount leak when
	findingexpectation
Date: Tue, 28 Nov 2006 14:14:08 +0100
Message-ID: <456C3620.9080209@trash.net>
References: <200611232315.kANNFVi3006773@toshiba.co.jp>
	<456B214A.5090207@trash.net>
	<200611271132.21563.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alan Ezust <alan.ezust@presinet.com>
In-Reply-To: <200611271132.21563.alan.ezust@presinet.com>
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

Alan Ezust wrote:
> I noticed many messages indicating that things are being applied to conntrack 
> and their related libs - but whenever I check my own checked out copy from 
> svn (rev 6698), it does not show me anything new to update, and it appears as 
> if nobody is committing to that particular part of the repo. Are you 
> committing these changes to a branch other than trunk?

This patch was against the kernel not the libraries. The others you
mention probably as well.
