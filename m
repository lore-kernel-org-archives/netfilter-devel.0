From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 3/3] tests/shell: add testcase to catch segfault if
 invalid syntax was used
Date: Fri, 13 May 2016 12:29:04 +0200
Message-ID: <CAOkSjBhTM2mA75dDXPPBmTNSUnqpNe2rG17Ld1Q8uA-4q278qg@mail.gmail.com>
References: <146296620273.3706.17267671338035433056.stgit@nfdev2.cica.es>
 <146296621327.3706.18265491927507888269.stgit@nfdev2.cica.es> <20160513094032.GC4008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35511 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbcEMK3Z convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 May 2016 06:29:25 -0400
Received: by mail-wm0-f46.google.com with SMTP id e201so16797578wme.0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2016 03:29:25 -0700 (PDT)
In-Reply-To: <20160513094032.GC4008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 May 2016 at 11:40, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, May 11, 2016 at 01:30:13PM +0200, Arturo Borrero Gonzalez wro=
te:
>> Let's add
>
> Applied.
>
> I have included in the commit log message that this refers to
> "evaluate: check for NULL datatype in rhs in lookup expr".

Oops, thanks, my fault.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
