From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.6 released
Date: Tue, 24 May 2011 14:31:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105241425240.1846@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105241039080.1846@blackhole.kfki.hu> <4DDB91CD.3080003@googlemail.com> <alpine.DEB.2.00.1105241329170.1846@blackhole.kfki.hu> <4DDB9C6A.9040308@googlemail.com> <alpine.DEB.2.00.1105241404390.1846@blackhole.kfki.hu>
 <4DDBA31B.4040406@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:60441 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1EXMbi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 08:31:38 -0400
In-Reply-To: <4DDBA31B.4040406@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 24 May 2011, Mr Dash Four wrote:

> > Currently I can suggest you that tune both the hashsize and maxelem
> > parameters: the hashsize tells the system the initial hash size (and thus
> > the used memory resource) while maxelem tells up to what number of elements
> > can be added to the set. You are free to enter quite high maxelem values, it
> > does not waste memory. As you add more and more elements, the hash size is
> > increased from the one specified by 'hashsize'. But you (or the SET targets)
> > can't add more elements than "maxelem".
> > 
> > When you save a set, the current hashsize is saved and not the one 
> > specified at set creation time.
> >   
> Ah, I see! So maxelem does not have an impact on system resources as 
> hashsize has, is that right? If that is the case, then I may as well 
> leave the default (64k) as I'd never exceed this value. Thanks for your 
> input, as always!

Yes, exactly. With the hashsize parameter, you tell the system how much 
memory is allocated for the set when created. With maxelem it is 
instructed at what point to stop increasing the set and refuse adding more 
elements.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
