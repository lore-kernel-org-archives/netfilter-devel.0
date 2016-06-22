From: =?UTF-8?Q?Roberto_Garc=c3=ada_Calero?= <rodanber@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Fix translation of
 --set-xmark option
Date: Wed, 22 Jun 2016 13:34:51 +0200
Message-ID: <46dba554-6a95-f202-12c9-f6aaa0ffe9c8@gmail.com>
References: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
 <20160622102342.GA6696@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arturo.borrero.glez@gmail.com, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35536 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbcFVLnA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 07:43:00 -0400
Received: by mail-wm0-f47.google.com with SMTP id v199so83811421wmv.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 04:41:58 -0700 (PDT)
In-Reply-To: <20160622102342.GA6696@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I misunderstood the explanation of the option. I'm going to fix that=20
right now.

Thanks for pointing out the error!

On 22/06/16 12:23, Florian Westphal wrote:
> rodanber@gmail.com <rodanber@gmail.com> wrote:
>> From: Roberto Garc=EDa <rodanber@gmail.com>
>>
>> Fix translation of MARK target's --set-xmark option.
>>
>> Before:
>>
>>  # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x=
64/0xaf
>>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0=
x64 and 0xaf
>>
>> After:
>>
>>   # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0=
x64/0xaf
>>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0=
x64 and \
>>   0xffffff50
>
> Hmm, I wonder if this is correct...  iptables man page says:
>
>  --set-xmark value[/mask]
>    Zeroes out the bits given by mask and XORs value into the packet
>    mark ("nfmark"). If mask is omitted, 0xFFFFFFFF is assumed.
>
> So the iptables command is supposed to
>
>    mark =3D skb->mark
>    mark =3D mark & ~0xaf
>    mark ^=3D 0x64
>    skb->mark =3D mark
>
> The proposed translation results in:
> nft --debug=3Dnetlink add rule ip mangle PREROUTING meta mark set mar=
k xor 0x64 and 0xffffff50
>  [ meta load mark =3D> reg 1 ]
>  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000040 ]
>  [ meta set mark with reg 1 ]
>
>  As you can see nft did perform the '0x64 and 0xffffff50' part in an
>  optimization pass so we end up not masking anything and then xor'ing
>  0x40.
>
> I think this should be:
> nft --debug=3Dnetlink add rule ip mangle PREROUTING meta mark set mar=
k and 0xffffff50 xor 0x64
>  [ meta load mark =3D> reg 1 ]
>  [ bitwise reg 1 =3D (reg=3D1 & 0xffffff50 ) ^ 0x00000064 ]
>  [ meta set mark with reg 1 ]
>
> which -- afaiu -- matches what the xtables target would do.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
