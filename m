From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] xml: json: Delete an immediatedate label in xml
 and json file.
Date: Wed, 9 Apr 2014 16:06:50 +0200
Message-ID: <CAOkSjBgGckw051iCrvT3i7G75zqpPaUnk3Za=dAwO5Fuoq+2qQ@mail.gmail.com>
References: <8a18f44c02d37f6035ea2d14c6aeea28ebfa7a6e.1397033348.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:36161 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaDIOHM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:07:12 -0400
Received: by mail-la0-f45.google.com with SMTP id hr17so1177035lab.4
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 07:07:10 -0700 (PDT)
In-Reply-To: <8a18f44c02d37f6035ea2d14c6aeea28ebfa7a6e.1397033348.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 April 2014 11:16, Ana Rey <anarey@gmail.com> wrote:
> It deletes the immediatedata label in the structure of json and xml f=
ile.

Hi Ana,

I've tested both patches. They seem to work here.

How ugly is the data_reg XML|JSON parsing code (my fault).

@pablo: patchwork may conflict with long lines.

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
