From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2][priv_data-condition][part 2/2][matches_and_targets]
Date: Sat, 30 Sep 2006 18:55:36 +0200
Message-ID: <451EA188.1050307@trash.net>
References: <200609250040.49298.max@nucleus.it>
	<200609251017.34183.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200609251017.34183.max@nucleus.it>
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

Massimiliano Hofer wrote:
>  net/netfilter/xt_CLASSIFY.c          |    3 +-
>  net/netfilter/xt_CONNMARK.c          |   18 ++++++-----
>  net/netfilter/xt_DSCP.c              |   21 +++++++-----
>  net/netfilter/xt_MARK.c              |   34 +++++++++++---------
>  net/netfilter/xt_NFQUEUE.c           |    3 +-
>  net/netfilter/xt_NOTRACK.c           |    3 +-
>  net/netfilter/xt_SECMARK.c           |   12 ++++---

CONNSECMARK appears to be missing.
