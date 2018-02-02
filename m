From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net] xt_cgroup: initialize info->priv in
 cgroup_mt_check_v1()
Date: Fri, 2 Feb 2018 12:58:49 +0100
Message-ID: <20180202115849.qcjwgdi3rpuqr4ik@salvia>
References: <20180131230247.1417-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180131230247.1417-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 31, 2018 at 03:02:47PM -0800, Cong Wang wrote:
> xt_cgroup_info_v1->priv is an internal pointer only used for kernel,
> we should not trust what user-space provides.

Applied, thanks Cong.
