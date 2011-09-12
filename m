From: Gidon Miller <gmiller@vasonanetworks.com>
Subject: Re: conntrack (nf_conn) locking question
Date: Mon, 12 Sep 2011 13:11:50 +0300
Message-ID: <CAOAcFN8DeYAk_sv+f=DrDykEqxd7jQ-yBKCBnqieHOr=RofY5g@mail.gmail.com>
References: <CAOAcFN-fXwCrtDu1snSAH-O5ud92bcBS4Dh8fR2m38pc=5hbTA@mail.gmail.com>
	<20110912084557.GA2080@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59414 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751204Ab1ILKLw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:11:52 -0400
Received: by mail-ww0-f54.google.com with SMTP id 5so404012wwf.35
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2011 03:11:50 -0700 (PDT)
In-Reply-To: <20110912084557.GA2080@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
thanks for your reply. can you please refer me to any documentation on
how to use ct extensions?
thanks,
Gidon

On Mon, Sep 12, 2011 at 11:45 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Thu, Sep 08, 2011 at 11:12:53AM +0300, Gidon Miller wrote:
> > Hi,
> > I hope I'm posting this question to the correct list. if not please
> > let me know where I should be posting.
> >
> > I'm writing a kernel module (against 2.6.32) to add functionality to
> > conntrack to maintain extra state information for certain tcp
> > connections.
>
> Better use one ct extension.
>
> > the way I'm doing this is by unregistering the l4proto handler for tcp
> > on module load and registering my own handler struct which is the same
> > except for the new(), destroy(), packet() and print_conntrack()
> > functions. my functions call the original tcp handler functions and
> > then perform some of their own logic - they change the ct->mark to
> > hold an id used to reference a table of "my" connection info (that
> > holds my state and other data). I also have xtables matcher and target
> > modules that reference this conntrack info and do some logic
> > accordingly.
> > therefore I'd like to protect my data and the nf_conn data while in my
> > handler functions.
> >
> > this raises a few questions:
> > 1. I see that xtables modules (such as xt_CONNMARK and xt_state) do
> > not take the ct->lock. what protects the ct entry in this case?
> > 2. since I cant take the ct->lock in my functions (because they call
> > the tcp functions who take the lock) its not clear to me how to
> > protect my data. in general, is my approach the correct one?
>
> The ct->lock is only used if you modify the internal TCP data for that
> ct flow, like it happens in the nf_conntrack_tcp code.
