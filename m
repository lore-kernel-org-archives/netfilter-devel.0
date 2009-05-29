From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP simultaneous open using iptables NAT?
Date: Sat, 30 May 2009 01:10:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905300051320.30481@blackhole.kfki.hu>
References: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com> <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:49267 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZE2XK6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2009 19:10:58 -0400
In-Reply-To: <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 28 May 2009, Jozsef Kadlecsik wrote:

> On Wed, 27 May 2009, Saatvik Agarwal wrote:
> 
> > For my research project in school, I am trying to establish TCP
> > connections when both hosts are behind full-cone NATs using TCP's
> > simultaneous open functionality. Unfortunately, it seems that iptables
> > does not support TCP simultaneous open. For my test environment, I
> > simulate a full-cone NAT using iptables. My iptables rule is exactly
> > as follows:
> > 
> > iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> 
> That rule cannot simulate full-cone NAT, because netfilter implements 
> port-restricted cone NAT.

In order to describe the mapping and filtering behaviour of netfilter as 
complete as possible, I have to add the following:

- According to the terminology of RFC 3489, netfilter implements port 
  restricted cone NAT. If the --random flag is specified to the 
  SNAT/MASQUERADE/... targets, it's better described as a symmetric NAT.
- According to the terminology of RFC 4787 and RFC 5382, netfilter
  implements
  - endpoint-independent mapping, if the --random flag is not 
    specified to the SNAT/MASQUERADE/... targets, otherwise it's an
    address and port-dependent mapping.
  - address and port-dependent filtering.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
