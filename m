From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 2 Jun 2009 13:51:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906021336080.11925@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu> <4A250DDA.1010406@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33554 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132AbZFBLvC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:51:02 -0400
In-Reply-To: <4A250DDA.1010406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Tue, 2 Jun 2009, Patrick McHardy wrote:

> Thanks Jozsef. Just one question:
> 
> > -	TCP_CONNTRACK_LISTEN,
> > +	TCP_CONNTRACK_SYN_SENT2,
> 
> is this constant already used in userspace? From your conntrack
> output above I'd assume the answer is yes, so we should keep it
> around as an alias to avoid compilation errors.

libnetfilter_conntrack has got it's own header file which defines 
TCP_CONNTRACK_LISTEN and it's string interpretation as "LISTEN" state. 
'conntrack' relies on libnetfilter_conntrack when translating the 
numerical id received from the kernel to the string value, that is the 
reason for the "misinterpretation" of the state. So from 
libnetfilter_conntrack and conntrack-tools point of view we can safely 
remove TCP_CONNTRACK_LISTEN.

I'm not aware of any project which would use the kernel header file 
directly, but that does not mean there isn't any. We might keep the 
symbol, of course. Shall I resend the patch with TCP_CONNTRACK_LISTEN 
preserved?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
