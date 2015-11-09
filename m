From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft synproxy integration
Date: Mon, 09 Nov 2015 20:13:51 +0000
Message-ID: <8670E62A-489B-41B4-A89B-AAF740264ACA@trash.net>
References: <20151109163015.GM8098@macbook.localdomain> <alpine.DEB.2.10.1511092030480.30088@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	bjornar.ness@gmail.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:51306 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752388AbbKIUN7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 15:13:59 -0500
In-Reply-To: <alpine.DEB.2.10.1511092030480.30088@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 9. November 2015 19:36:06 GMT+00:00, schrieb Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
>On Mon, 9 Nov 2015, Patrick McHardy wrote:
>
>> Basically the idea is:
>> 
>> * don't mark the first SYN untracked and have it create a conntrack
>as normal
>> * direct that SYN to synproxy
>> * mark the connection as proxied, which will avoid setting the
>ASSURED bit when
>>   receiving our spoofed reply
>> * only set assured once we have the connection fully established
>> 
>> This would create a conntrack, but keep it evictable under pressure.
>So the
>> cost would be ct set up, but we could tear it down at any point when
>we're
>> under pressure. The synproxy target can handle both connections with
>and
>> without a conntrack.
>[...] 
>> The ct state rule could actually be created automatically since it is
>a
>> dependency.
>[...]
>> The method of using notrack would of course still be possible.
>
>I like the idea: the notrack method would still be supported and the
>"do 
>conntrack but with safety-net" way would be possible too. Looks cool!

Thanks Jozsef. I'm thinking it's the best of both worlds myself. Implementation should be quite easy, I'll give it a try.


>
>Best regards,
>Jozsef
>-
>E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
>PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>Address : Wigner Research Centre for Physics, Hungarian Academy of
>Sciences
>          H-1525 Budapest 114, POB. 49, Hungary


-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
