From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 1/3] evaluate: check for NULL datatype in rhs in
 lookup expr
Date: Fri, 13 May 2016 12:28:20 +0200
Message-ID: <CAOkSjBirWETS_2V0WcR+qGCPfg_ub_B5uAUfiq_g0Tqz-4AwFA@mail.gmail.com>
References: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es> <20160513093856.GA4008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35001 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEMK2l convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 06:28:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id e201so2786284wme.2
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 03:28:40 -0700 (PDT)
In-Reply-To: <20160513093856.GA4008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 May 2016 at 11:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 11, 2016 at 01:30:02PM +0200, Arturo Borrero Gonzalez wro=
te:
>> If we are evaluating an EXPR_SET_REF, check if right->dtype is not N=
ULL.
>> We can hit SEGFAULT if for whatever reason the referenced object doe=
s not
>> exists.
>>
>> Using this testfile (note the invalid set syntax):
>>
>> % cat test.nft
>> flush ruleset
>> add table t
>> add chain t c
>> add set t s {type ipv4_addr\;}
>> add rule t c ip saddr @s
>>
>> Without this patch:
>>
>> % nft -f test.nft
>> Segmentation fault
>>
>> With this patch:
>>
>> % nft -f test.nft
>> t.nft:4:28-28: Error: syntax error, unexpected junk, expecting newli=
ne or semicolon
>> add set t s {type ipv4_addr\;}
>>                            ^
>> t.nft:4:13-29: Error: set definition does not specify key data type
>> add set t s {type ipv4_addr\;}
>>             ^^^^^^^^^^^^^^^^^
>> t.nft:5:23-24: Error: the referenced object does not exists
>
> I have reworded this to: "the referenced set does not exist"
>

Ok, I used the generic word 'object' because this could apply to maps a=
s well.

>> add rule t c ip saddr @s
>>              ~~~~~~~~ ^^
>
> Applied, thanks Arturo.

thanks

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
