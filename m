From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2/2] Basic support for printing nft_data_reg
 in XML format.
Date: Wed, 3 Apr 2013 14:38:38 +0200
Message-ID: <CAOkSjBhNJAfa18_W8deetS=97X18H-5W=Z5n1a8txYm3WOzEjw@mail.gmail.com>
References: <20130329153155.30122.21803.stgit@nfdev.cica.es>
 <20130329153432.30122.86772.stgit@nfdev.cica.es> <20130402114123.GC9973@localhost>
 <CAOkSjBjM57H+XAX7h5YFOPcfF_Hj3H_vfnMpBg6tnQVTee1CKA@mail.gmail.com> <20130402193229.GA16053@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:53640 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761873Ab3DCMi7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:38:59 -0400
Received: by mail-la0-f50.google.com with SMTP id ec20so1391691lab.9
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Apr 2013 05:38:58 -0700 (PDT)
In-Reply-To: <20130402193229.GA16053@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/4/2 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Tue, Apr 02, 2013 at 07:18:39PM +0200, Arturo Borrero Gonzalez wro=
te:
>> If cmp and bitwise are going to always have DATA_VALUE, and imm
>> depending on what was set, I think we could do:
>>
>> int nft_data_reg_snprintf(char *buf, union data_reg *data, int type,=
 ...)
>> switch(type)
>> return nft_data_reg_snprintf_'type'(buf, data, ...)
>
> where 'type' can be: value, verdict or chain.
>
>> And the same applies when parsing XML.
>
> Exactly.

I propose to use this format:

for DATA_VALUE:

<expr type=3Dcmp>
   [...]
   <cmpdata>
     <data_reg type=3Dvalue>
      <len>N</len>
      <data0>reg->val[i]</data0>
       [...]
       <dataN>reg->val[n]</dataN>
    </data_reg>
  </cmpdata>
</expr>

This way we also export/import the len of reg->val (actually reg->len)

=46or DATA_VERDICT or DATA_CHAIN:
<data_reg type=3Dverdict>
    <verdict>int</verdict>
    <chain>string</chain>
</data_reg>

assuming verdict and chain are always used together, despite of node
'<verdict>' or '<chain>' being not set (but present with no value)
--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
