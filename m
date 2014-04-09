From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables-20140407 compilation error
Date: Wed, 9 Apr 2014 12:26:49 +0200
Message-ID: <CAOkSjBgUGK8caypKrDWCz-usHc7LVYOOVwKh2Qr6tEMP6WKz1Q@mail.gmail.com>
References: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Nazim Wahid Djafar <nwd.dev@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:59894 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaDIK1L convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:27:11 -0400
Received: by mail-lb0-f171.google.com with SMTP id w7so972793lbi.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 03:27:10 -0700 (PDT)
In-Reply-To: <CABtPJSsULt0MKYHacfGtLbJFLrepcGGB5uUZ5CSaQkNdTb2kSg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 April 2014 11:17, Nazim Wahid Djafar <nwd.dev@gmail.com> wrote:
> There is an error of compilation of nftables-20140407 on Debian 7.0
> Wheezy (eglibc 2.13 )

Hi! thanks for your report.

Would you like to test this debian package?

https://github.com/aborrero/pkg-nftables

you will need git-buildpackage and others build-deps.

$ sudo aptitude install git-buildpackage
$ gbp clone https://github.com/aborrero/pkg-nftables
$ cd pkg-nftables
$ git-buildpackage

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
