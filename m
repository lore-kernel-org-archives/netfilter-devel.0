From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nf_conntrack_standalone: fix error
 return code
Date: Mon, 1 Apr 2013 13:20:14 +0200
Message-ID: <20130401112014.GA4087@localhost>
References: <CAPgLHd-=NwowPW_A6-owg6NE=zOCaTOC6fqDZh3mCVFrWMcN6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, yongjun_wei@trendmicro.com.cn,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPgLHd-=NwowPW_A6-owg6NE=zOCaTOC6fqDZh3mCVFrWMcN6Q@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Mar 27, 2013 at 09:57:10PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in function
> nf_conntrack_standalone_init().

Applied to the nf tree, thanks.
