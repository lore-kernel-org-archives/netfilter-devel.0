From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: ipv6: fix oops when defragmenting locally
 generated fragments
Date: Wed, 24 Oct 2018 00:04:31 +0200
Message-ID: <20181023220431.d6q22vhm7x6yjrot@breakpoint.cc>
References: <CANP3RGeX5=c=Lb+Pkg89zD7zQ_Z1T8oPJRCkorNCdghmofYXxg@mail.gmail.com>
 <20181023144716.19746-1-fw@strlen.de>
 <CANP3RGfCDumc40Tr2gr0KHenQ6x29tWAjhnM+8yk7nK5nNHRFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Lorenzo Colitti <lorenzo@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Linux NetDev <netdev@vger.kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANP3RGfCDumc40Tr2gr0KHenQ6x29tWAjhnM+8yk7nK5nNHRFA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Maciej Żenczykowski <maze@google.com> wrote:
> >         ret = -EINPROGRESS;
> >         if (fq->q.flags == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
> > -           fq->q.meat == fq->q.len &&
> > -           nf_ct_frag6_reasm(fq, skb, dev))
> > -               ret = 0;
> > -       else
> > +           fq->q.meat == fq->q.len) {
> > +               unsigned long orefdst = skb->_skb_refdst;
> > +
> > +               skb->_skb_refdst = 0UL;
> > +               if (nf_ct_frag6_reasm(fq, skb, dev))
> > +                       ret = 0;
> > +               skb->_skb_refdst = orefdst;
> > +       } else {
> >                 skb_dst_drop(skb);
> > +       }
> >
> >  out_unlock:
> >         spin_unlock_bh(&fq->q.lock);
> > --
> > 2.18.1
> >
> 
> I don't quite follow how this fixes things, but I'll trust you on it.

The problematic spot is skb_morph() in nf_ct_frag6_reasm(), when we hit
this code path we take dst from a dst-less skb that got queued earlier.

> (nor do I understand why only 4.9 LTS appears to crash with a null ptr deref)

Newer kernels need nft or iptables rule that enables defrag, such as
"ip6tables -A INPUT -m conntrack --ctstate NEW"; 4.9 still enables it by
default.
