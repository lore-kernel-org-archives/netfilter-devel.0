From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: must check mark attributes
 vs NULL
Date: Fri, 21 Sep 2018 10:14:58 +0200
Message-ID: <20180921081458.l42yaho6r6sfd76f@salvia>
References: <000000000000f4bf02057653dc0a@google.com>
 <20180920215306.10018-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        kristian.evensen@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920215306.10018-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 20, 2018 at 11:53:06PM +0200, Florian Westphal wrote:
> else we will oops (null deref) when the attributes aren't present.
> 
> Also add back the EOPNOTSUPP in case MARK filtering is requested but
> kernel doesn't support it.

Applied, thanks Florian.
