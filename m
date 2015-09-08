From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH libnftnl 0/3] use nftnl_ prefix
Date: Tue, 8 Sep 2015 08:58:27 +0200
Message-ID: <CAOkSjBit=Ci3B8sb=FL2SHOAHtXtJKPGd57rMyS6-4ZxUdY1yw@mail.gmail.com>
References: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
 <20150902150255.GA10168@salvia> <20150907181428.GA16080@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35036 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbbIHG6s convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 02:58:48 -0400
Received: by lbpo4 with SMTP id o4so48164989lbp.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2015 23:58:46 -0700 (PDT)
In-Reply-To: <20150907181428.GA16080@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 September 2015 at 20:14, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
>
> Please, let me know if you have more renaming suggestions since
> libnftnl will be out soon and it would be great if we can avoid this
> stuff in the future.
>

Perhaps:

 nftnl_rule_u64_set(...)
 nftnl_rule_u64_get(...)
 nftnl_set_u32_set(...)
 nftnl_set_u32_get(...)
 ...


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
