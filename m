From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 15:05:36 +0100
Message-ID: <CAOkSjBhiPh9D7Rj2J5gwJK7njwFLjBUUuDQC6U+VHitjaOhPYw@mail.gmail.com>
References: <20140121110645.GC25197@macbook.localnet> <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <52DE5E10.5000403@linux.intel.com> <20140121114955.GA27718@macbook.localnet>
 <52DE6331.4030902@linux.intel.com> <20140121121147.GB30577@macbook.localnet>
 <52DE655B.9020105@linux.intel.com> <20140121122532.GA30955@macbook.localnet> <52DE6CE5.3000702@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:49480 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaAUOF5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:05:57 -0500
Received: by mail-la0-f47.google.com with SMTP id el20so4101933lab.34
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 06:05:56 -0800 (PST)
In-Reply-To: <52DE6CE5.3000702@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 January 2014 13:49, Tomasz Bursztyka
<tomasz.bursztyka@linux.intel.com> wrote:
>
> I messed up on how this replace command could be used, never mind the=
n.
>

Well, I was working on these ops:

% nft export <xml|json>
% nft import <xml|json>

The `export' patch is in shape (i'm sending it right now for you to rev=
iew).

The problem comes in the `import' operation.
I think that importing the ruleset means that any previous ruleset is
wiped, and I'm working in that way.

In my import code, I flush rules (with a batch), then query sets,
delete each one, query chains, delete each and query tables, delete.
(then add the ruleset)

I surprisingly discovered that when deleting tables, I get EBUSY:

if (!list_empty(&table->chains) || !list_empty(&table->sets))
   return -EBUSY;

because the set list is not empty.
But if I add in my code a sleep(1); between deleting sets and deleting
tables, then all go fine.

Is this the race condition you were referring to, Patrick? I can send
the `import' patch if you want.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
