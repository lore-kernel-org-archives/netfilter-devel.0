From: Giacomo <delleceste@gmail.com>
Subject: Re: iptables -t nat -A OUTPUT -j DNAT ... checksum incorrect
Date: Thu, 6 Aug 2009 09:02:03 +0200
Message-ID: <885896af0908060002i6b3cebf9s827dbd600c037f93@mail.gmail.com>
References: <885896af0908050553kefeadd2l2fb30190ade2f521@mail.gmail.com>
	 <9e9f4e5f0908051512v5651ea7ah8be49fa19f3577dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Fabricio Archanjo <farchanjo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63556 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZHFHCE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:02:04 -0400
Received: by ewy10 with SMTP id 10so555745ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Aug 2009 00:02:03 -0700 (PDT)
In-Reply-To: <9e9f4e5f0908051512v5651ea7ah8be49fa19f3577dc@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/8/6 Fabricio Archanjo <farchanjo@gmail.com>:
> Giacomo,
> You need use the PREROUTING table. I guess so.
>
> Att.

Hi, thanks for your answer.
No, this rule changes destination address/port of outgoing packets
(redirection).

Regards, Giacomo

>
> On Wed, Aug 5, 2009 at 9:53 AM, Giacomo <delleceste@gmail.com> wrote:
>>
>> Hi to all.
>>
>> With the rule
>>
>>
>> iptables -t nat -A OUTPUT -p tcp -j DNAT -d 151.8.71.28
>> --to-destination 140.105.5.88:8080
>>
>>
>> I see the GET http request with checksum incorrect (on the wireshark
>> traffic analyzer):
>>
>> Checksum: x incorrect, should be y (maybe caused by "TCP checksum
>> offload?)
>>
>> Is it normal?
>>
>> Why does this happen?
>>
>> Thanks
>>
>> Giacomo
>>
>> --
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-=
devel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>



--=20
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
