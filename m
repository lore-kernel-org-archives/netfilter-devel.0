From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH v2] Basic support for printing nft_data_reg in
 XML format.
Date: Tue, 9 Apr 2013 22:26:48 +0200
Message-ID: <CAOkSjBg9WD5E_ePjdat-E8vb1cXAMTafaF-FyW4-e49q7Uo7Rw@mail.gmail.com>
References: <20130408083022.9188.50453.stgit@nfdev.cica.es> <20130409194255.GA5544@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:41799 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936293Ab3DIU1K convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:27:10 -0400
Received: by mail-la0-f53.google.com with SMTP id fp13so86954lab.12
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2013 13:27:09 -0700 (PDT)
In-Reply-To: <20130409194255.GA5544@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/4/9 Pablo Neira Ayuso <pablo@netfilter.org>:
>
> Cannot use "data" instead of immediate data? This is nested in
> <immediate>...</immediate>, it seems redundant to me.

Understood. And I will fix it.

But let me explain why I did it:

for example, cmp is using <cmpdata>
<cmpdata> has <data_reg></data_reg> which can also be redundant.

But all around the XML printing (including sets, an incoming patch)
i've been nesting the data_reg into another XML node, so you could
easily see (also the XML parser) the difference between (for example.
in set) nft_set_elem->key and nft_set_elem->data.
As I needed to nest in nft_set_elem I decided to follow a constant
line and do nest all data_reg.

If you liked this reason, we can choose a new tag for immediate and
cmp (or a general naming convention) to avoid be so redundant. If not,
I'll fix it and resend.

regards
--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
