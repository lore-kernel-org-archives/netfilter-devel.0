From: Florian Westphal <fw@strlen.de>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Wed, 2 May 2018 00:24:06 +0200
Message-ID: <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Kristian Evensen <kristian.evensen@gmail.com> wrote:
> On Tue, May 1, 2018 at 8:50 PM, Kristian Evensen
> <kristian.evensen@gmail.com> wrote:
> > Does anyone have any idea of what could be wrong, where I should look
> > or other things I can try? I tried to space the requests out a bit in
> > time (I inserted a sleep 1 between them), and then the problem went
> > away.
> 
> I should learn to always go through everything one last time before
> sending an email. First of all, I see that both requests are treated
> as new.

Normal when nfqueue is in use.

> Second, on my router, new requests are sent to user space for
> marking, which explains the large delay in processing. When removing
> the NFQUEUE-rule + handling and marking statically, my problem goes
> away and I get an answer for both packets.

Yes, because 2nd packet finds the conntrack entry created by the first
one.

> However, I do have one question. In my application, both packets are
> assigned the same mark. Shouldn't they then match the same conntrack
> entry, or am I missing something since that seems not to be the case?

The 2nd packet creates a new conntrack entry, because the conntrack
entry created by the first one is not inserted into global table yet.

This happens as last step, after packet has traversed all chains.
When nfqueue is used, this gets delayed, and 2nd packet will be dropped
as the insertion step finds that another packet created same flow
already.

I'm not sure what the best way to solve this is, we either need
to insert earlier in nfqueue case, or do conflict resolution in nfqueue
case (and perhaps also nat undo? not sure).
