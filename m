From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][CONNTRACK-TOOL] getopts_long returns integer
Date: Thu, 07 Sep 2006 17:06:03 +0200
Message-ID: <4500355B.8050208@trash.net>
References: <45001FBA.1070501@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45001FBA.1070501@netfilter.org>
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

Pablo Neira Ayuso wrote:
> This patch was posted by a ARM guy, it seems that it got lost. Please apply

No, its already in SVN:

[PATCH] conntrack: Fix option parsing for ARM (Philip Craig
<philipc@snapgear.com>)

The result of getopt_long() was assigned to a char, which defaults to
unsigned
