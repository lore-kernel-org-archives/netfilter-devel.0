From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 12:42:36 +0100
Message-ID: <CAOkSjBgW0nNs-V+V47-KEnu0GWPc2U0rNc30waRNXExgUwWtoA@mail.gmail.com>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
 <20140110005015.GA18032@localhost> <CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
 <20140110103758.GA4732@localhost> <CAOkSjBjFnfRhQ+3seVLx_i-JrzdQwcefD_U_COByX=EidOoXBw@mail.gmail.com>
 <CAKfDRXgGAGfa95kxDgH5A2ybyre+e4E0+5bGmrRryofHt__JJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:57536 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAJLnE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:43:04 -0500
Received: by mail-la0-f48.google.com with SMTP id n7so3068932lam.7
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 03:42:58 -0800 (PST)
In-Reply-To: <CAKfDRXgGAGfa95kxDgH5A2ybyre+e4E0+5bGmrRryofHt__JJQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10 January 2014 12:37, Kristian Evensen <kristian.evensen@gmail.com>=
 wrote:
> Hi,
>
> On Fri, Jan 10, 2014 at 12:06 PM, Arturo Borrero Gonzalez
> <arturo.borrero.glez@gmail.com> wrote:
>> Should I patch all and switch to enum nft_registers?
>
> I can do ct.c as a part of reworking the ct set-patch.
>

Good, I'll handle the others.

thanks.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
