From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 12:06:29 +0100
Message-ID: <CAOkSjBjFnfRhQ+3seVLx_i-JrzdQwcefD_U_COByX=EidOoXBw@mail.gmail.com>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
 <20140110005015.GA18032@localhost> <CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
 <20140110103758.GA4732@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:60791 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaAJLGv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:06:51 -0500
Received: by mail-la0-f42.google.com with SMTP id ec20so3124678lab.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 03:06:50 -0800 (PST)
In-Reply-To: <20140110103758.GA4732@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 January 2014 11:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
>
> That's inconsistent and needs to be fixed. My suggestion is to fix it
> by using u32 for registers. Thanks.

cmp [0] also uses uint8_t for a register.

Also, others [1] use 'enum nft_registers'.

Should I patch all and switch to enum nft_registers?

regards

[0] http://git.netfilter.org/libnftables/tree/src/expr/cmp.c#n29
[1] http://git.netfilter.org/libnftables/tree/src/expr/immediate.c#n27
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
