From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter/nflog: nflog-range does not truncate
 packets (userspace)
Date: Fri, 1 Jul 2016 16:30:02 +0200
Message-ID: <20160701143002.GA14239@salvia>
References: <20160624204231.GA3062@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu, johunt@akamai.com,
	davem@davemloft.net, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, pai.vishwain@gmail.com,
	ilubashe@akamai.com, jdollard@akamai.com
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160624204231.GA3062@akamai.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 24, 2016 at 04:42:31PM -0400, Vishwanath Pai wrote:
> Added tests to libxt_NFLOG.t for the new option --nflog-size
> 
> --
> 
> netfilter/nflog: nflog-range does not truncate packets
> 
> The option --nflog-range has never worked, but we cannot just fix this
> because users might be using this feature option and their behavior would
> change. Instead add a new option --nflog-size. This option works the same
> way nflog-range should have, and both of them are mutually exclusive. When
> someone uses --nflog-range we print a warning message informing them that
> this feature has no effect.
> 
> To indicate the kernel that the user has set --nflog-size we have to pass a
> new flag XT_NFLOG_F_COPY_LEN.
> 
> Also updated the man page to reflect the new option and added tests to
> extensions/libxt_NFLOG.t

Applied to iptables userspace, thanks.
