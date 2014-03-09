From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 1/2] src/rule: Removed mandatory attribute
 printing in rules
Date: Sun, 9 Mar 2014 14:14:23 +0100
Message-ID: <CAOkSjBhtRP+aVF8qNcP0uwV4LFRFxnZCS1GCKox1uw7Vfimuew@mail.gmail.com>
References: <20140309125959.23270.43422.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:41135 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaCINOp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 09:14:45 -0400
Received: by mail-la0-f45.google.com with SMTP id hr17so3933589lab.4
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2014 06:14:43 -0700 (PDT)
In-Reply-To: <20140309125959.23270.43422.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 March 2014 13:59, Alvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>
> Before this patch, the program tried to print some attribute
> that maybe the user hasn't defined for printing. We can't
> assume that the user want to print some attribute that we have put
> mandatory in the rules. Example:
>
> Before this patch, it's mandatory have a rule with family
> and this is the output:
>
> {"rule":{"family":"ip","handle":4...
> <rule><family>ip</family><handle>4</handle>...
>
> Now, we can print rule without some attribute:
>
> {"rule":{"handle":4...
> <rule><handle>4</handle>...
>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---

Hi there!

These attributes are no longer mandatory? What is the idea behind this?

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
