From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix incorrect logic in nf_conntrack_init_net
Date: Tue, 10 Apr 2012 14:36:22 +0200
Message-ID: <20120410123622.GB30763@1984>
References: <1333850908-3108-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1333850908-3108-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Apr 08, 2012 at 10:08:28AM +0800, Gao feng wrote:
> in function nf_conntrack_init_net,when nf_conntrack_timeout_init falied,
> we should call nf_conntrack_ecache_fini to do rollback.
> but the current code calls nf_conntrack_timeout_fini.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Applied, thanks.
