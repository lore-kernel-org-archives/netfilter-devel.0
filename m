From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 1/2] netfilter/nflog: nflog-range does not truncate
 packets
Date: Thu, 23 Jun 2016 19:34:23 +0200
Message-ID: <20160623173423.GA2284@salvia>
References: <20160621185846.GA6646@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, johunt@akamai.com,
	daviem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pai.vishwain@gmail.com,
	ilubashe@akamai.com, jdollard@akamai.com
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160621185846.GA6646@akamai.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 21, 2016 at 02:58:46PM -0400, Vishwanath Pai wrote:
> netfilter/nflog: nflog-range does not truncate packets
> 
> li->u.ulog.copy_len is currently ignored by the kernel, we should truncate
> the packet to either li->u.ulog.copy_len (if set) or copy_range before
> sending it to userspace. 0 is a valid input for copy_len, so add a new
> flag to indicate whether this was option was specified by the user or not.
> 
> Add two flags to indicate whether nflog-size/copy_len was set or not.
> XT_NFLOG_F_COPY_LEN is for XT_NFLOG and NFLOG_F_COPY_LEN for nfnetlink_log
> 
> On the userspace side, this was initially represented by the option
> nflog-range, this will be replaced by --nflog-size now. --nflog-range would
> still exist but does not do anything.

Applied, thanks!
