From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: must check mark attributes
 vs NULL
Date: Sun, 23 Sep 2018 09:48:58 +0200
Message-ID: <CAKfDRXj87vZF+=Y=SKURmxw87BoK2jwvbWm2W-2jz_-yari1pA@mail.gmail.com>
References: <000000000000f4bf02057653dc0a@google.com> <20180920215306.10018-1-fw@strlen.de>
 <20180921081458.l42yaho6r6sfd76f@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        syzbot+e45eda8eda6e93a03959@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Network Development <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180921081458.l42yaho6r6sfd76f@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Florian,
On Fri, Sep 21, 2018 at 10:15 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Sep 20, 2018 at 11:53:06PM +0200, Florian Westphal wrote:
> > else we will oops (null deref) when the attributes aren't present.
> >
> > Also add back the EOPNOTSUPP in case MARK filtering is requested but
> > kernel doesn't support it.
>
> Applied, thanks Florian.

Thanks for fixing my embarrassing mistake!

BR,
Kristian
