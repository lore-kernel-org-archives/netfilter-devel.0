From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 30 Dec 2013 10:56:28 -0700
Message-ID: <CANLsYkx34A97NwJyFb05MT=zneT8ET=Nyz7HTGEDWHhGAZP_-Q@mail.gmail.com>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
	<1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
	<20131218095322.GA4740@localhost>
	<CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
	<20131219194339.GA4561@localhost>
	<CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
	<20131221085509.GA4230@localhost>
	<CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
	<20131230173655.GA21288@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20131230173655.GA21288@localhost>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 30 December 2013 10:36, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Dec 29, 2013 at 02:53:15PM -0700, Mathieu Poirier wrote:
>> On 21 December 2013 01:55, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Fri, Dec 20, 2013 at 01:34:00PM -0700, Mathieu Poirier wrote:
>> >> On 19 December 2013 12:43, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > [...]
>> >> > Thinking again on the event delivery, I think it's better if the
>> >> > nfacct match using the new --quota does not deliver the event itself.
>> >> > You can use libnetfilter_queue instead, eg.
>> >> >
>> >> >         iptables -I INPUT -p icmp \
>> >> >                  -m nfacct icmp --quota 12345 --mode bytes --match-once \
>> >> >                  -j NFLOG --nflog-prefix "icmp: " --nflog-group 34
>> >> >
>>
>> Thinking further on this...
>>
>> Unless I'm missing something the above only specifies when to log
>> quota transgression, hence introducing the need to write yet another
>> rule do explicitly deal with the packet.  My previous solution logged
>> quota excess _and_ dealt with the packet.
>
> What kind of "deal with the packet" you need to make in case you
> reach the quota? Please, elaborate your use case with hypothetical
> (iptables) examples so I can help better.

Apologies for not expressing myself clearly.

iptables -I OUTPUT -p http \
        -m nfacct --nfacct-name icmp-limit --quota 10000 -j REJECT

Upon reaching the limit of 10000 byte of http traffic, any outgoing
http packets will be dropped and a single broadcast message will be
sent to user space.  That is because the match explicitly takes care
of sending the notification.

With your proposal:

iptables -I OUTPUT -p http \
         -m nfacct --nfacct-name http-limit --quota 10000 --match-once \
         -j NFLOG --nflog-prefix "http: " --nflog-group 34

will log the quota reached event but won't prevent further http
traffic from going out.  One could instinctively add another rule
right after the above one, something like:

iptables -I OUTPUT -p http \
         -m nfacct --nfacct-name http-limit --quota 10000 \
         -j REJECT

but that won't work either because the packet/byte could will be
incremented twice.

>
>> Using ' nfulnl_log_packet()' (if even possible) would seem hackish to me.
>
> That don't like that choice either.
