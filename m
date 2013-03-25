From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nfnetlink_queue: fix error return code
 in nfnetlink_queue_init()
Date: Mon, 25 Mar 2013 20:32:52 +0100
Message-ID: <20130325193252.GA3476@localhost>
References: <CAPgLHd-WKwgAUeXH9C7OvnEmJiqZt7CJh=tZVqm5Aq0DKcqVcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, yongjun_wei@trendmicro.com.cn,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPgLHd-WKwgAUeXH9C7OvnEmJiqZt7CJh=tZVqm5Aq0DKcqVcA@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 22, 2013 at 07:28:18PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.

Applied, thanks. BTW, this patch is a good candidate for the net tree.
