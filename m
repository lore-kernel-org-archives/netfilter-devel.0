From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_queue: remove pointless
 conditional before kfree_skb()
Date: Mon, 10 Sep 2012 11:15:44 +0200
Message-ID: <20120910091544.GB5484@1984>
References: <CAPgLHd_dNe3ZLzkAZC7p6V7oQLohmFQxfPjVtK-SBhXG1yYxWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, yongjun_wei@trendmicro.com.cn,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPgLHd_dNe3ZLzkAZC7p6V7oQLohmFQxfPjVtK-SBhXG1yYxWw@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Aug 28, 2012 at 09:14:15PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove pointless conditional before kfree_skb().

Applied, thanks.
