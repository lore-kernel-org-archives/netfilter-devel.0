From: Joe Stringer <joestringer@nicira.com>
Subject: Re: [PATCH nf-next 0/4] netfilter: rework netfilter ipv6 defrag
Date: Wed, 21 Oct 2015 09:52:22 -0700
Message-ID: <CANr6G5x4ZTvNBYtEPyPopk7RhgYwf_nYxQXkCkoO6PD+h_BDRg@mail.gmail.com>
References: <1445112865-31523-1-git-send-email-fw@strlen.de>
 <CANr6G5zvmj_tL5Pt6-70GQ4dTJXLewX9A4uMGC_0OFzXYQVdew@mail.gmail.com>
 <20151020081716.GH4386@breakpoint.cc> <CANr6G5xW7m2SXFiU22pFVD6uvDj5ymX=jZkRJk2vMYQoJykvLw@mail.gmail.com>
 <20151020205306.GK4386@breakpoint.cc> <20151021124245.GA10299@salvia> <20151021145048.GC31323@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>,
	Andy Zhou <azhou@nicira.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20151021145048.GC31323@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 21 October 2015 at 07:50, Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > I can then wait for that change to pop up in nf-next and just resend
>> > this series (which will then undo that change).
>>
>> I'd rather get things fixes for the existing code. This would also
>> allow simple passing back to -stable, then we can move forward discuss
>> and review your rework with sufficient time.
>
> Joe, could you take care of this and submit a OVS fix to net tree?
>
> (just add that call to nf_ct_frag6_consume_orig and take
>  the morph change directly into the OVS callpath)
>
> I will then resubmit all of this at some later point.
>
> Thanks.

Sure thing.
