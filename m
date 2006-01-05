From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] use HOPLIMIT metric as TTL of TCP reset sent by REJECT
 [was: Re: please fix TARPIT]
Date: Thu, 05 Jan 2006 09:21:12 +0100
Message-ID: <43BCD6F8.8020706@trash.net>
References: <20051221.221552.70499588.davem@davemloft.net>	<Pine.LNX.4.61.0601030833560.23554@yvahk01.tjqt.qr>	<43BA5E7C.1090008@trash.net>
	<200601050808.k0588nH1012513@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601050808.k0588nH1012513@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Should ipt_REJECT use metric, too ? ip6_REJECT has already use it.

Looks good. Dave, please apply on top of my patches.

> BTW, I'm not familiar with TARPIT, but ipt_REJECT seems to have the codes
> to fix the other issues David pointed out.

Yes, looks like we could use some of the ipt_REJECT code.
But we decided to move TARPIT out of pom after moving to
something apt-get like anyway, so I'd rather spend time
on that.
