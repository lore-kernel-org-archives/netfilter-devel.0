From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf] netfilter: log: Check param to avoid overflow in
 nf_log_set
Date: Tue, 30 Aug 2016 11:54:27 +0200
Message-ID: <20160830095427.GA20414@salvia>
References: <1472466328-5595-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1472466328-5595-1-git-send-email-fgao@ikuai8.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 29, 2016 at 06:25:28PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The nf_log_set is an interface function, so it should do the strict sanity
> check of parameters. Convert the return value of nf_log_set as int instead
> of void. When the pf is invalid, return -EOPNOTSUPP.

Applied to nf-next, thanks.
