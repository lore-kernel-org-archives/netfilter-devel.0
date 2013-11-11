From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/3] ipset: Fix malformed output from list/save for ICMP
 types in port field.
Date: Mon, 11 Nov 2013 22:35:41 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1311112235160.8236@blackhole.kfki.hu>
References: <2351390.3tInbbydSl@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:57318 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab3KKVfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:35:43 -0500
In-Reply-To: <2351390.3tInbbydSl@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 7 Nov 2013, Sergey Popovich wrote:

> Found with ipset 6.12.1, but upstream version is still affected.
> 
> Creating set of dimension three, adding elements to it and then
> displaying gives following results:
> -----------------------------------
> 
>  # ipset create test-1 hash:ip,port,ip
>  # ipset add test-1 192.0.2.1,icmp:echo-request,192.0.2.1
>  # ipset add test-1 192.0.2.1,icmp:ttl-zero-during-reassembly,192.0.2.1
>  # ipset list test-1
>  Name: test-1
>  Type: hash:ip,port,ip
>  Header: family inet hashsize 1024 maxelem 65536
>  Size in memory: 16608
>  References: 0
>  Members:
>  192.0.2.1,icmp:ttl-zero-during-reass,192.0.2.1
>  192.0.2.1,icmp:echo-re,192.0.2.1
> 
> Same results with -output save|xml.
> 
> ipset_print_proto_port() from lib/print.c returns incorrect length
> of printed string when ICMP/ICMPv6 specified in port field.

Patch is applied, thanks.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
