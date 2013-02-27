From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Wed, 27 Feb 2013 20:57:21 +0000
Message-ID: <512E7331.10304@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost> <512D0BA4.7060809@googlemail.com> <20130226214707.GA3555@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:61307 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3B0U5f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:57:35 -0500
Received: by mail-lb0-f171.google.com with SMTP id gg13so815979lbb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2013 12:57:34 -0800 (PST)
In-Reply-To: <20130226214707.GA3555@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Pablo Neira Ayuso wrote:
> I see. Then my new proposal is to add a new automagic function to
> round the output to the most expressive measure, would be somehow
> similar to xtables_print_num:
> 
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=blob;f=libxtables/xtables.c;h=009ab9115f6fd687a762a2552f89ac0b81ee1a42;hb=HEAD#l1915
I might be seeing this wrong and if so I apologize, but is this the same/similar function which exists in the "old" iptables accounting, as well as seen for packets/bytes counter when iptables -L -vn is executed? If so, that isn't very appropriate as I indicated in my previous posting.

Pablo, do you think there is something wrong with the "iec" and "si" options already in place? If you think that I've done something wrong, please let me know because this was one of the reasons for placing the changes (and including the patches) in the code I attached before. I would gladly benefit from a feedback on that code.
 
> Would that fit into your needs?
Short answer: no, not really.

As I already posted, the "iec" and "si" options deal with the two numbering standards (IEC and the "old" SI), have 3-digit decimal point resolution and, most importantly in this case, they were put in place to cover traffic which is of unpredictable/unknown quantity/volume. Going from our own experience, this covers about 20% of the traffic we measure. 

For the vast majority of all other traffic, we "lock" the denominator and use the appropriate format ("kib", "mib" etc). This is so that if that traffic is different from what we expected to see, this is instantly reflected in the numbers and is immediately flagged for further analysis.

Let me illustrate this with a small example: if we use "3pl,mib" format options for a specific type of traffic and we start getting byte count numbers like, for example, "140,666,825.688MiB" (in other words, over 134TiB), then this is instantly flagged to be analyzed to find why that traffic shot our pre-determined "expectation" from being in the "MiB range" and jumped two ranges and got into "TiB" territory.

The packet count is also a different matter. Even though in vast majority of cases we use the "3pl" format, this is by no means set solid in stone, so packet count format would also needs to be configured for each traffic measure (i.e. nfacct object).

The "old" SI-type options ("kb","mb" and so on) were also put there for a reason - we still have people who are used to this measure, so it is more convenient for them to have this working range of options, which they could use. I hope I have explained this clear, let me know if this is not the case.


MZ
