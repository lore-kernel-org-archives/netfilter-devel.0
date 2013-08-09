From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 11/13] expr: payload: add nft_str2base function
Date: Fri, 9 Aug 2013 13:34:18 +0200
Message-ID: <CAOkSjBiWX9vyZOKVpgzmjW9AQ8ey7uyg7vkoZZJnjJJ5XKkLHg@mail.gmail.com>
References: <20130809111148.29819.95689.stgit@Ph0enix> <20130809111415.29819.19869.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Eric Leblond <eric@regit.org>
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:34733 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3HILek convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:34:40 -0400
Received: by mail-la0-f54.google.com with SMTP id ea20so2928514lab.13
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:34:38 -0700 (PDT)
In-Reply-To: <20130809111415.29819.19869.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 August 2013 13:14, Alvaro Neira <alvaroneay@gmail.com> wrote:
> -err:
> -       errno =3D EINVAL;
> -       return -1;

not going to err anymore, obviously
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
