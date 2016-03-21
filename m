From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] Add systemd files
Date: Mon, 21 Mar 2016 11:35:56 +0100
Message-ID: <CAOkSjBiU2mdYuE-G6nnm0oAXu+ZijK=ZU=x3CqrFPjJgZuXMvA@mail.gmail.com>
References: <1458520740-13951-1-git-send-email-seblu@seblu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33560 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbcCUKgS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2016 06:36:18 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so145736974wml.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 03:36:16 -0700 (PDT)
In-Reply-To: <1458520740-13951-1-git-send-email-seblu@seblu.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 March 2016 at 01:39, S=C3=A9bastien Luttringer <seblu@seblu.net> =
wrote:
> This is the current systemd service files I wrote for Arch Linux.
> A Fedora maintainer suggest to move them to the upstream to share the=
m
> between distribution.
> ---
>  configure.ac                   |  1 +
>  files/Makefile.am              |  2 +-
>  files/systemd/Makefile.am      |  1 +
>  files/systemd/nftables-reload  |  3 +++
>  files/systemd/nftables.service | 15 +++++++++++++++
>  5 files changed, 21 insertions(+), 1 deletion(-)
>  create mode 100644 files/systemd/Makefile.am
>  create mode 100755 files/systemd/nftables-reload
>  create mode 100644 files/systemd/nftables.service

NACK.

This has been discussed many times already.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
