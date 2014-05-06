From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] netnet,netportnet: Fix value range support for
 IPv4
Date: Tue, 6 May 2014 11:06:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1405061105220.10540@blackhole.kfki.hu>
References: <cover.1399275196.git.popovich_sergei@mail.ru> <013ebb6b972846e27933e99c2d016492c58564a6.1399275196.git.popovich_sergei@mail.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:38085 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934344AbaEFJGR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 May 2014 05:06:17 -0400
In-Reply-To: <013ebb6b972846e27933e99c2d016492c58564a6.1399275196.git.popovich_sergei@mail.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 5 May 2014, Sergey Popovich wrote:

> Ranges of values are broken with hash:net,net and hash:net,port,net.
> 
> hash:net,net
> ============
> 
>    # ipset create test-nn hash:net,net
>    # ipset add test-nn 10.0.10.1-10.0.10.127,10.0.0.0/8
> 
>    # ipset list test-nn
>    Name: test-nn
>    Type: hash:net,net
>    Revision: 0
>    Header: family inet hashsize 1024 maxelem 65536
>    Size in memory: 16960
>    References: 0
>    Members:
>    10.0.10.1,10.0.0.0/8
> 
>    # ipset test test-nn 10.0.10.65,10.0.0.1
>    10.0.10.65,10.0.0.1 is NOT in set test-nn.
>    # ipset test test-nn 10.0.10.1,10.0.0.1
>    10.0.10.1,10.0.0.1 is in set test-nn.
> 
> hash:net,port,net
> =================
> 
>    # ipset create test-npn hash:net,port,net
>    # ipset add test-npn 10.0.10.1-10.0.10.127,tcp:80,10.0.0.0/8
>    # ipset list test-npn
>    Name: test-npn
>    Type: hash:net,port,net
>    Revision: 0
>    Header: family inet hashsize 1024 maxelem 65536
>    Size in memory: 17344
>    References: 0
>    Members:
>    10.0.10.8/29,tcp:80,10.0.0.0
>    10.0.10.16/28,tcp:80,10.0.0.0
>    10.0.10.2/31,tcp:80,10.0.0.0
>    10.0.10.64/26,tcp:80,10.0.0.0
>    10.0.10.32/27,tcp:80,10.0.0.0
>    10.0.10.4/30,tcp:80,10.0.0.0
>    10.0.10.1,tcp:80,10.0.0.0
>    # ipset list test-npn
>    # ipset test test-npn 10.0.10.126,tcp:80,10.0.0.2
>    10.0.10.126,tcp:80,10.0.0.2 is NOT in set test-npn.
>    # ipset test test-npn 10.0.10.126,tcp:80,10.0.0.0
>    10.0.10.126,tcp:80,10.0.0.0 is in set test-npn.
> 
>    # ipset create test-npn hash:net,port,net
>    # ipset add test-npn 10.0.10.0/24,tcp:80-81,10.0.0.0/8
>    # ipset list test-npn
>    Name: test-npn
>    Type: hash:net,port,net
>    Revision: 0
>    Header: family inet hashsize 1024 maxelem 65536
>    Size in memory: 17024
>    References: 0
>    Members:
>    10.0.10.0,tcp:80,10.0.0.0
>    10.0.10.0,tcp:81,10.0.0.0
>    # ipset test test-npn 10.0.10.126,tcp:80,10.0.0.0
>    10.0.10.126,tcp:80,10.0.0.0 is NOT in set test-npn.
>    # ipset test test-npn 10.0.10.0,tcp:80,10.0.0.0
>    10.0.10.0,tcp:80,10.0.0.0 is in set test-npn.
> 
> Correctly setup from..to variables where no IPSET_ATTR_IP_TO{,2}
> attribute is given, so in range processing loop we construct proper
> cidr value. Check whenever we have no ranges and can short cut in
> hash:net,net properly. Use unlikely() where appropriate, to comply
> with other modules.

Good catch, patch is applied. Thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
