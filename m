From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf_tables RFH PATCH] netfilter: nf_tables: add set_elem notifications
Date: Fri, 28 Mar 2014 14:24:18 +0100
Message-ID: <CAOkSjBgZdpGZ0So5T=Z=R=TOz-CD=HLvsRFCJsGY6FnF0AQhGg@mail.gmail.com>
References: <20140328114622.8896.14752.stgit@nfdev.cica.es> <20140328122802.GA13468@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:33430 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaC1NYj convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:24:39 -0400
Received: by mail-la0-f48.google.com with SMTP id gf5so3703693lab.35
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2014 06:24:38 -0700 (PDT)
In-Reply-To: <20140328122802.GA13468@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 March 2014 13:28, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Mar 28, 2014 at 12:46:22PM +0100, Arturo Borrero Gonzalez wro=
te:
>> This patch adds set_elems notifications.
>>
>> When a set_elem is added/deleted, all listening peers in userspace w=
ill
>> receive the corresponding notification.
>
> Now that Patrick discovered the problem, please address some more
> changes.

Thanks Patrick, Pablo.

I will submit a new version shortly.

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
