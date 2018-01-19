From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: Fix trailing semicolon
Date: Fri, 19 Jan 2018 14:10:19 +0100
Message-ID: <20180119131019.hkafxoruqsifhlax@salvia>
References: <20180116145101.7190-1-luisbg@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Luis de Bethencourt <luisbg@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180116145101.7190-1-luisbg@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jan 16, 2018 at 02:51:01PM +0000, Luis de Bethencourt wrote:
> The trailing semicolon is an empty statement that does no operation.
> Removing it since it doesn't do anything.

Applied.
