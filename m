From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: return booleans instead of integers
Date: Fri, 19 Jan 2018 14:02:08 +0100
Message-ID: <20180119130208.ewf7fmw4qddr6isc@salvia>
References: <20180118232512.GA22242@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180118232512.GA22242@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 18, 2018 at 05:25:12PM -0600, Gustavo A. R. Silva wrote:
> Return statements in functions returning bool should use
> true/false instead of 1/0.
> 
> These issues were detected with the help of Coccinelle.

Applied, thanks.
