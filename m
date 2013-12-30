From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH 1/1] netfilter: xtables: add quota support to nfacct
Date: Mon, 30 Dec 2013 15:17:20 -0700
Message-ID: <CANLsYkxr2eRyz0aWDD8OMJDf2YWpwg3SOBpEhoopfy6N+kzfWg@mail.gmail.com>
References: <1386780798-24374-1-git-send-email-mathieu.poirier@linaro.org>
	<1386780798-24374-2-git-send-email-mathieu.poirier@linaro.org>
	<20131218095322.GA4740@localhost>
	<CANLsYkxMzdFCpJ3456PPd8KsEPi-U70kJDqGv8c3BhCsKY8RiQ@mail.gmail.com>
	<20131219194339.GA4561@localhost>
	<CANLsYkzoa0E6T8ZGYmKHSPdFyGkLeQw8_dsB_NAJx9YA2qD8uw@mail.gmail.com>
	<20131221085509.GA4230@localhost>
	<CANLsYkx32_sUzZvy697Vhyu7cBUaoYtB__FNTvdhwWDguLmT2Q@mail.gmail.com>
	<20131230173655.GA21288@localhost>
	<CANLsYkx34A97NwJyFb05MT=zneT8ET=Nyz7HTGEDWHhGAZP_-Q@mail.gmail.com>
	<20131230214653.GP29632@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>,
	JP Abgrall <jpa@google.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20131230214653.GP29632@breakpoint.cc>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hey Florian - I think that is an acceptable compromise.  The LOG chain
and rules are extra but it is setup only once and as such scale well.

Thank you for that,
Mathieu

On 30 December 2013 14:46, Florian Westphal <fw@strlen.de> wrote:
> Mathieu Poirier <mathieu.poirier@linaro.org> wrote:
>> Upon reaching the limit of 10000 byte of http traffic, any outgoing
>> http packets will be dropped and a single broadcast message will be
>> sent to user space.  That is because the match explicitly takes care
>> of sending the notification.
>>
>> With your proposal:
>>
>> iptables -I OUTPUT -p http \
>>          -m nfacct --nfacct-name http-limit --quota 10000 --match-once \
>>          -j NFLOG --nflog-prefix "http: " --nflog-group 34
>>
>> will log the quota reached event but won't prevent further http
>> traffic from going out.  One could instinctively add another rule
>> right after the above one, something like:
>>
>> iptables -I OUTPUT -p http \
>>          -m nfacct --nfacct-name http-limit --quota 10000 \
>>          -j REJECT
>>
>> but that won't work either because the packet/byte could will be
>> incremented twice.
>
> The usual workaround is to create custom chains to deal with this,
> i.e.
> iptables -N LOG_DROP_HTTP
> iptables -A LOG_DROP_HTTP -j NFLOG --nflog-prefix "http: " --nflog-group 34
> iptables -A LOG_DROP_HTTP -j REJECT
> iptables -I OUTPUT -p http -m nfacct ... -j LOG_DROP_HTTP
