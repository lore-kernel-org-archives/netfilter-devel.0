From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Sat, 21 Dec 2013 09:55:09 +0100
Message-ID: <20131221085509.GA4230@localhost>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
 <1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
 <20131218095322.GA4740@localhost>
 <CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
 <20131219194339.GA4561@localhost>
 <CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Dec 20, 2013 at 01:34:00PM -0700, Mathieu Poirier wrote:
> On 19 December 2013 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > Thinking again on the event delivery, I think it's better if the
> > nfacct match using the new --quota does not deliver the event itself.
> > You can use libnetfilter_queue instead, eg.
> >
> >         iptables -I INPUT -p icmp \
> >                  -m nfacct icmp --quota 12345 --mode bytes --match-once \
> >                  -j NFLOG --nflog-prefix "icmp: " --nflog-group 34
> >
> > The --once parameter tells to match only if you just crossed the quota
> > limit (so the event is sent once). The idea is to use nflog to deliver
> > the event, which is way more flexible as it includes useful
> > information.
> 
> I'm not against the idea as it is less code for me to write.  Is this
> "--match-one" thing already available?  If not I'll come up with it.

The --match-once that I propose is specific to nfacct, so you need to
add a new flag to indicate this matching mode and return true only
once for that rule.

> Just to be clear, if "--match-one" isn't specified a message is sent
> each time we try to send a packets and the quota has been reached.

Exactly, in the example I provided above, if no --match-once is
specified, you will get a log message per packet over quota.
