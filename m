From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Mon, 18 Apr 2005 00:00:42 +0200
Message-ID: <4262DC8A.7070109@trash.net>
References: <423DA194.40100@trash.net>	<200503300205.j2U25fCc021930@toshiba.co.jp>	<42503569.5080406@trash.net>
	<200504080758.j387wkif011777@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200504080758.j387wkif011777@toshiba.co.jp>
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
> This patch makes send_reset() look xfrm policy and deletes unnecessary
> dst_hold().

Looks good, thanks. I've applied it to pom, but can't commit right
now, there is some permission problem with SVN. I'll commit it once
its working again.

Regards
Patrick
