From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: Re: Drop a packet while keeping the conntrack alive
Date: Thu, 21 Mar 2013 17:16:49 +0100
Message-ID: <CACd4Q01FvedCAipv37VS9k3zToqeZUCXZPrA+8ayAADGfUewEg@mail.gmail.com>
References: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
 <20130321015306.GB3779@localhost> <CACd4Q00XP-OS8=9QM-Oyks9sp2qSGzQBYLHvmCh6r3J-JgjjWA@mail.gmail.com>
 <20130321160720.GA14783@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49927 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab3CUQRL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:17:11 -0400
Received: by mail-wg0-f47.google.com with SMTP id dt14so636043wgb.26
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Mar 2013 09:17:09 -0700 (PDT)
In-Reply-To: <20130321160720.GA14783@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 21, 2013 at 5:07 PM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:

> That "use" field in the nf_conn object is a refcounter. In SMP, you
> may have several packets traveling through the stack referencing to
> the same conntrack object. The refcount is initially set to 1 because
> there is a timer that releases the conntrack if it expires.
>
> You may also have a conntrack entries that are related to another
> master conntrack (eg. FTP helper scenario: the control flow is the
> master conntrack, and all data flows are related to it). In that case=
,
> the refcount is also incremented depending on the amount of reference=
s
> to it.
>
> nf_conntrack_find_get increments the refcount, nf_ct_put decrements i=
t
> and it checks if it has become 0, in that case the nf_conn object is
> released.

Now that's clearer. Thank you very much!


--
Nicolas Ma=C3=AEtre
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
