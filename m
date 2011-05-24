From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 13:44:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDB91CD.3080003@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4DDB91CD.3080003@googlemail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 May 2011, Mr Dash Four wrote:

> > The next ipset package release will come with code simplifications, which
> > mean dropping some support:
> > 
> > - iptree and iptreemap type support will be removed, because the automatic
> >   conversion to hash:ip is not fully backward compatible. The hash:ip and
> > hash:net types can be used instead.
> > - kernel version support below 2.6.37 will be dropped, to make code
> >   maintenance easier and more straightforward
> >   
> What are your plans with regards to the last point? The reason I am asking is
> because I am still on .35 (the last "stable" kernel released by Fedora) and I
> might not be able to use new releases if you introduce this restriction.

Hm, 2.6.35 can lessen the maintenance burden compared to the currently 
minimal supported version 2.6.34, because the main trouble comes from the 
differences between .34 and .35. So I think I can remove the older kernel
supports gradually and keep supporting 2.6.35 for a while.
 
> Also, would you consider my suggestion to include the number of members
> registered in a set to be displayed in the set headers (something like
> "Members: 15156") - this would help with managing the number of members in
> that set, which would be particularly useful for sets with large number of
> members.

The problem with it that the reported number can be inaccurate, at least 
in two cases:

- Elements can time out, so even if whatever number reported, by the
  time it's displayed, the set can even be completely empty. In the case
  of a huge set, it can even occur that the number of elements reported
  does not match the actual number of elements listed.
- Sets can be updated by the SET target

The first one is the main reason I dropped reporting the number of 
elements (the initial design of the new ipset included it).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
