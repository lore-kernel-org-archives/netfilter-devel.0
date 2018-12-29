From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix a missing check of nla put failure
Date: Sat, 29 Dec 2018 02:50:35 +0100
Message-ID: <20181229015035.schsfpi6iikphmxr@salvia>
References: <20181221064623.59988-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pakki001@umn.edu, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181221064623.59988-1-kjlu@umn.edu>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 21, 2018 at 12:46:23AM -0600, Kangjie Lu wrote:
> If nla_nest_start() may fail. The fix checks its return value and goes
> to nla_put_failure if it fails.

Applied, thanks.
