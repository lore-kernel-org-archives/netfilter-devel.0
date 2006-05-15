From: Philip Craig <philipc@snapgear.com>
Subject: Re: ulogd2 and nflog prefix
Date: Mon, 15 May 2006 19:05:05 +1000
Message-ID: <44684441.8060502@snapgear.com>
References: <4467EC50.3030907@snapgear.com>
	<44681346.3000301@trash.net>	<446826EF.1070004@snapgear.com>
	<44682889.107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44682889.107@trash.net>
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

On 05/15/2006 05:06 PM, Patrick McHardy wrote:
> Right, I somehow though the prefix was also configured using netlink,
> which is of course wrong. In that case I think nfnetlink_log should
> just 0-terminate the string. BTW, Is there any reason why the prefix
> is truncated to NFULNL_PREFIXLEN?

I just noticed that net/netfilter/nf_log.c limits the prefix to
NF_LOG_PREFIXLEN=128.  Don't know if this affects the decision.
