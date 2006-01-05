From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] use HOPLIMIT metric as TTL of TCP reset sent by REJECT
Date: Thu, 05 Jan 2006 13:16:58 -0800 (PST)
Message-ID: <20060105.131658.48040141.davem@davemloft.net>
References: <43BA5E7C.1090008@trash.net>
	<200601050808.k0588nH1012513@toshiba.co.jp>
	<43BCD6F8.8020706@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43BCD6F8.8020706@trash.net>
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
Date: Thu, 05 Jan 2006 09:21:12 +0100

> Yasuyuki KOZAKAI wrote:
> > Should ipt_REJECT use metric, too ? ip6_REJECT has already use it.
> 
> Looks good. Dave, please apply on top of my patches.

All 18 patches, and this one, applied and pushed to Linus.
Thanks.
