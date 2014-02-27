From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables] suggestion: system-wide sets
Date: Thu, 27 Feb 2014 13:15:36 +0100
Message-ID: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43910 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaB0MP6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:15:58 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so1601272lbj.17
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2014 04:15:57 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there!

I can't remember this subject being discussed in the near past.

Why not using system-wide sets? Or at least, family-wide sets?

=46rom the user point of view, I think is very interesting to define
sets that can be used in rules all across the ruleset, same set in
different tables and families.

Being family-wide is what ipset does, and I'm sure is what most people
will expect.

On the other hand, I understand this would be a major change at this po=
int.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
