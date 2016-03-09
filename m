From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Re: Regarding libxt_multiport translation in nft
Date: Wed, 9 Mar 2016 20:04:28 +0530
Message-ID: <56E03474.1000408@gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia>
 <56DFCB53.8090601@gmail.com>
 <CAOkSjBimhamOTLjrQghozFRdj=FvRMO=nkGG0ADui7fw5-7KQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34194 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbcCIOeM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 09:34:12 -0500
Received: by mail-pf0-f182.google.com with SMTP id 129so41989425pfw.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Mar 2016 06:34:11 -0800 (PST)
In-Reply-To: <CAOkSjBimhamOTLjrQghozFRdj=FvRMO=nkGG0ADui7fw5-7KQQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 09 March 2016 03:36 PM, Arturo Borrero Gonzalez wrote:
> On 9 March 2016 at 08:05, FaTe <gokuvsvegita@gmail.com> wrote:
>> Hello Pablo,
>>
>> I would require some guidance regarding the libxt_multiport translation in nft.
>>
>> If the translation is over ip4 family :
>> $ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACCEPT
>> nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport { 3-4 } counter accept
>>                              ^^^^^^^^^^^
>>                              this causes problem.
>> Similarly for ipv6 :
>> $ ip6tables-translate -A input -p tcp -m multiport --dports 1024:2048,2049:3333 -j ACCEPT
>> nft add rule ip6 filter input meta l4proto tcp dport { 1024-2048,2049-3333 } counter accept
>>                               ^^^^^^^^^^^^
>>                               this is causing problem.
>>
>> both the strings "ip protocol" and "meta l4proto" is not introduced by libxt_multiport.
>> And in the absence of both , the command works.
>>
>> For example ,
>> $ nft add rule ip filter INPUT tcp dport { 3-4 } tcp sport { 3-4 } counter accept
>>
>> $ nft add rule ip6 filter input tcp dport { 1024-2048,2049-3333 } counter accept
>>
>> Any comment regarding this behaviour ?
> 
> They are different statements, rules should be something like:
>  * meta l4proto tcp tcp dport XX
>  * ip protocol tcp tcp dport XX
> 
> However, the two statements are redundants... the second implies the first.

Thanks Arturo !
It works.
