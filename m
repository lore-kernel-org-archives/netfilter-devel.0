From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 14:19:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105241404390.1846@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDB91CD.3080003@googlemail.com> <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu> <4DDB9C6A.9040308@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:57455 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab1EXMT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:19:29 -0400
In-Reply-To: <4DDB9C6A.9040308@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 24 May 2011, Mr Dash Four wrote:

> > The problem with it that the reported number can be inaccurate, at least in
> > two cases:
> > 
> > - Elements can time out, so even if whatever number reported, by the
> >   time it's displayed, the set can even be completely empty. In the case
> >   of a huge set, it can even occur that the number of elements reported
> >   does not match the actual number of elements listed.
> > - Sets can be updated by the SET target
> > 
> > The first one is the main reason I dropped reporting the number of elements
> > (the initial design of the new ipset included it).
> >   
> I see, reasonable point.
> 
> OK, would it be possible then to get this figure when I use restore - I am
> asking for this because, as you already know, ip ranges may mean inserting
> more elements than the range itself and the indicator I used up until now to
> determine how many set members I would have (the number of lines in my restore
> file) is no longer a reliable indicator, so I would need to know how many
> members I have inserted as a result of restore in order to determine the
> maxelem value, adjust it and thus save system resources. Do you see my point?

Currently I can suggest you that tune both the hashsize and maxelem 
parameters: the hashsize tells the system the initial hash size (and thus 
the used memory resource) while maxelem tells up to what number of 
elements can be added to the set. You are free to enter quite high maxelem 
values, it does not waste memory. As you add more and more elements, the 
hash size is increased from the one specified by 'hashsize'. But you (or 
the SET targets) can't add more elements than "maxelem".

When you save a set, the current hashsize is saved and not the one 
specified at set creation time.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
