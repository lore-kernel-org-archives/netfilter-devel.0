From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 3/6] internal: rework parsing symbol logic
Date: Wed, 8 Jan 2014 13:20:51 +0100
Message-ID: <CAOkSjBibj-66qf2mr=26d1GPfASJFjb+9Bbyv2LOsi3rUkuyYw@mail.gmail.com>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114726.12841.59406.stgit@nfdev.cica.es> <20140107231813.GC16894@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41080 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaAHMVN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:21:13 -0500
Received: by mail-lb0-f178.google.com with SMTP id c11so1209025lbj.23
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2014 04:21:12 -0800 (PST)
In-Reply-To: <20140107231813.GC16894@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 January 2014 00:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> We don't save any ifdef.

Well, we need at least one ifdef per format. I don't see how we can
get rid of them.

This patch just condensates the logic to one single point, also adding
the void definition, which is good for other patches in the series.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
