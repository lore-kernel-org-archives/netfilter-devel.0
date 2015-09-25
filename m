From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd] allowing DisableExternalCache in alarm mode
Date: Fri, 25 Sep 2015 13:38:38 +0200
Message-ID: <CAOkSjBhUEJESS=_Z2oui9FFNG7RM+ZRfJpFY2WWYWbVjN3LfOw@mail.gmail.com>
References: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
 <20150828164912.GD3436@salvia> <CAOkSjBhxLk2beq70jZCTKtO8K09UcSj5jNh2H-9wvCzSL0XxeA@mail.gmail.com>
 <20150901164421.GA3320@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35250 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbbIYLi7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 07:38:59 -0400
Received: by wicge5 with SMTP id ge5so16734313wic.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2015 04:38:57 -0700 (PDT)
In-Reply-To: <20150901164421.GA3320@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 1 September 2015 at 18:44, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> On Mon, Aug 31, 2015 at 09:55:23AM +0200, Arturo Borrero Gonzalez wro=
te:
>> On 28 August 2015 at 18:49, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>> >
>> > Are these FTP data flows? I'm asking this because the master
>> > connection (control flow) may be missing in the conntrack table, t=
hus
>> > the ENOENT error.
>>
>> Makes sense.
>>
>> Would you consider accepting the patch?
>
> I think you can fix the problem that you're noticing by extending
> timer_add().
>
> Note that the general idea behind the alarm approach is to insert a
> timer with a random time wait in unit from 0..M seconds.
>
> A quick workaround to address this is that master conntracks are
> placed in the time range from 0..N/2, then you place non-master
> conntrack entries in the range from N/2+1 to M. Then, unless there is
> packet loss, most likely the expected conntrack will find the master
> one.
>
> It should be just a few more extra lines away from this oneliner.

I keep thinking about this, and I have a few questions:

timer_add() seems to manage timers for both internal and external cache=
s.
Is it okay to include the workaround you mentioned for *both* internal
and external caches?

This is what I've understood: the master conntrack in the internal
cache of the sending node is vanishing before the non-master
conntrack, and then the non-master conntrack is being synced again to
the receiving node without the associated master conntrack. Is this
assumption true?

Other possibility is that both master and non-master conntracks are
sycned, but then the receiving node fails to somehow inject to the
kernel in the required order.

Could you please give me additional hints?

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
