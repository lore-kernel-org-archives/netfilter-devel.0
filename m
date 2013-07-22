From: Daniel Collins <daniel.collins@smoothwall.net>
Subject: Re: Packet loss when using NFQUEUE and nf_conntrack_ipv4
Date: Mon, 22 Jul 2013 09:33:02 +0100
Message-ID: <CAOmdcgXQnqFXkAFzn4SHVzQBWz6_kpVVJO9MAbj7tYmyAe5jTg@mail.gmail.com>
References: <CAOmdcgVVgPxB2BV0qxoXVquPVt-21+JvYq0ywFu7=RiJ4i7JXQ@mail.gmail.com>
	<20130719092547.GF22686@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:35855 "HELO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756701Ab3GVIdE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:33:04 -0400
Received: by mail-ie0-f178.google.com with SMTP id u16so15019258iet.9
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2013 01:33:03 -0700 (PDT)
In-Reply-To: <20130719092547.GF22686@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Yes.  The packets are tossed because the conntrack they're associated
> with is unconfirmed, and on reinject they clash with the unconfirmed
> ct of the 1st packet that has been inserted into the conntrack table.

Is there a way it can be worked around other than queueing in the raw
table? This isn't suitable for me as I want to check the connmark to
tell if packets in a given stream should be queued.

I've been trying to follow the code involved and I don't understand
what purpose the confirmed flag serves. Why is adding to the conntrack
table saved until the very end of netfilter processing and why does
nf_conntrack_confirm have to drop packets when an entry already exists
in the table rather than using it?

Thanks

--=20
Daniel Collins
Junior Developer
daniel.collins@smoothwall.net

Smoothwall Ltd
Phone: +44 (0=AD) 8701 999500
www.smoothwall.net

Smoothwall Limited is registered in England, Company Number: 4298247
and whose registered address is 1 John Charles Way, Leeds, LS12 6QA
United Kingdom
Any opinions stated in this message are solely those of the author.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
