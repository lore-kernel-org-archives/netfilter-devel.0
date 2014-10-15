From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables PATCH 3/3] netfilter: nf_tables: add new expression nft_redir
Date: Wed, 15 Oct 2014 12:11:02 +0200
Message-ID: <CAOkSjBhA0JA+AnN8Un7__JbA7=p7OoQ9syPMPSwkL_ymRwkPdg@mail.gmail.com>
References: <20141014172231.5983.37941.stgit@nfdev.cica.es>
 <20141014172242.5983.11604.stgit@nfdev.cica.es> <20141015100619.GC4885@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:48384 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaJOKLX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:11:23 -0400
Received: by mail-la0-f49.google.com with SMTP id q1so734223lam.22
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2014 03:11:22 -0700 (PDT)
In-Reply-To: <20141015100619.GC4885@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 October 2014 12:06, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Tue, Oct 14, 2014 at 07:22:42PM +0200, Arturo Borrero Gonzalez wro=
te:
>> This new expression provides NAT in the redirect flavour, which is t=
o
>> redirect packets to local machine.
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>>  include/net/netfilter/nft_redir.h        |   18 ++++++
>>  include/uapi/linux/netfilter/nf_tables.h |   16 +++++
>>  net/ipv4/netfilter/Kconfig               |    9 +++
>>  net/ipv4/netfilter/Makefile              |    1
>>  net/ipv4/netfilter/nft_redir_ipv4.c      |   76 +++++++++++++++++++=
++++++
>>  net/ipv6/netfilter/Kconfig               |    9 +++
>>  net/ipv6/netfilter/Makefile              |    1
>>  net/netfilter/Kconfig                    |    9 +++
>>  net/netfilter/Makefile                   |    1
>>  net/netfilter/nft_redir.c                |   93 +++++++++++++++++++=
+++++++++++
>>  10 files changed, 233 insertions(+)
>>  create mode 100644 include/net/netfilter/nft_redir.h
>>  create mode 100644 net/ipv4/netfilter/nft_redir_ipv4.c
>>  create mode 100644 net/netfilter/nft_redir.c
>>

Hi Pablo,

thanks for your comments. I will address all of them.

BTW, the last chunk you mentioned is clearly poor code, bad reviewed by=
 myself.

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
