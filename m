From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 12:37:35 +0100
Message-ID: <CAKfDRXgGAGfa95kxDgH5A2ybyre+e4E0+5bGmrRryofHt__JJQ@mail.gmail.com>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
	<20140110005015.GA18032@localhost>
	<CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
	<20140110103758.GA4732@localhost>
	<CAOkSjBjFnfRhQ+3seVLx_i-JrzdQwcefD_U_COByX=EidOoXBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48916 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaAJLhg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:37:36 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so4447819pdj.19
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 03:37:36 -0800 (PST)
In-Reply-To: <CAOkSjBjFnfRhQ+3seVLx_i-JrzdQwcefD_U_COByX=EidOoXBw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Jan 10, 2014 at 12:06 PM, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> Should I patch all and switch to enum nft_registers?

I can do ct.c as a part of reworking the ct set-patch.

-Kristian
