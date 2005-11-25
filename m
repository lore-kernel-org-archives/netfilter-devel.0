From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC] [PATCH] nf_conntrack_netlink port take#2
Date: Fri, 25 Nov 2005 14:00:33 +0900 (JST)
Message-ID: <200511250500.jAP50YL2008800@toshiba.co.jp>
References: <43836FFE.3020504@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <43836FFE.3020504@eurodev.net>
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


Hi, Pablo,

From: Pablo Neira <pablo@eurodev.net>
Date: Tue, 22 Nov 2005 20:22:38 +0100

> Hi,
> 
> Sorry for the bad timing. Here attached the take#2 of the
> nf_conntrack_netlink port. It includes a layer-3 abstraction as
> suggested. Attached two patches:
> 
> - required modifications for nf_conntrack (modifs-take2.patch)
> - a diff against ip_conntrack_netlink to make easy the review (x).
> 
> The whole nf_conntrack_netlink file is available at:
> 
> http://people.netfilter.org/pablo/nf_conntrack_netlink.c

As far as I read roughly, it looks good. I'll read this deeply
and write a patch for ICMPv6 this weekend.

Regards,

-- Yasuyuki Kozakai
