From: James King <t.james.king@gmail.com>
Subject: Re: Anyway to add data to connection tracking?
Date: Mon, 19 Apr 2010 14:35:22 -0700
Message-ID: <u2q38bcb3ec1004191435i95b3ebeld75eff9c47f71d70@mail.gmail.com>
References: <i2y8363055a1004191240jeb1bb313r3f414cdc89b0468e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39999 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab0DSVfX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:35:23 -0400
Received: by vws5 with SMTP id 5so2472581vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2010 14:35:22 -0700 (PDT)
In-Reply-To: <i2y8363055a1004191240jeb1bb313r3f414cdc89b0468e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 19, 2010 at 12:40 PM, Justin Yaple <yaplej@gmail.com> wrote=
:
> I was wondering if its possible to use conntrack for this rather than
> re-invent the wheel. =A0My application needs to be alerted when a
> session is being removed from the conntrack table so it can cleanup
> any data related to that session within the program. =A0Given the
> particular requirements I was not sure if the existing conntrack tabl=
e
> would be suitable for doing this.
>
> What are your though on trying to use conntrack vs using an internal
> connection tracking method within the application?

On Mon, Apr 19, 2010 at 12:40 PM, Justin Yaple <yaplej@gmail.com> wrote=
:
> I am working on an application that has to track data within
> custom/non-standard TCP options within the packets of each TCP
> session.  It has to check the existence of, and examine the data
> within these options then save that data about the session somewhere.
> I had previously written my own session tracking system using a large
> jump table to linked lists of a custom session structure in case of
> collisions with my hashing function.
>
> I was wondering if its possible to use conntrack for this rather than
> re-invent the wheel.  My application needs to be alerted when a
> session is being removed from the conntrack table so it can cleanup
> any data related to that session within the program.  Given the
> particular requirements I was not sure if the existing conntrack tabl=
e
> would be suitable for doing this.
>
> What are your though on trying to use conntrack vs using an internal
> connection tracking method within the application?

Accounting, NAT, and the conntrack helpers use ct_extend to store
private per-conntrack data.  For an out of tree module, you'll need to
maintain a small kernel patch to add an enumeration to
nf_conntrack_extend.h, and add a function call to init_conntrack() and
ctnetlink_create_conntrack() to add the private area when the
conntrack is initialized, as it needs to be allocated before the
conntrack is confirmed.  If your private structure contains any
pointers, you'll also have specify a destroy callback in your module's
nf_ct_ext_type structure to make sure memory gets cleaned up properly.
 nf_conntrack_acct is probably a good module to look at for usage.

HTH,
James
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
