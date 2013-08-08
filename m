From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: PROBLEM: Netfilter time matching matches all packets when time
 start and time stop is the same
Date: Thu, 8 Aug 2013 18:02:06 +0200
Message-ID: <20130808160206.GA7487@localhost>
References: <CAK+MRYuFUCvkker9sq7LFa42t=vQ7FhWwzz37Mtw3sLMZTJ+EQ@mail.gmail.com>
 <20130801112444.GE21352@unicorn.suse.cz>
 <CAHo-Ooz+Wz23kMBL-LgWw6HxpzQr7hJYJZNWkinOyCB1w+41zw@mail.gmail.com>
 <51FB251E.9040605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Michal Kubecek <mkubecek@suse.cz>, kaber@trash.net,
	kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: Henry Lee <henryronlee@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51FB251E.9040605@gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Fri, Aug 02, 2013 at 11:18:54AM +0800, Henry Lee wrote:
[...]
> I wouldn't use a timestart == timestop rule manually. But if I
> create iptables rules in a program or a script, this case may
> happen.
> Rejecting this rule seems a little bit harsh, in my opinion, since
> it doesn't look so unacceptable.

I cannot take this patch since others may be relaying in the current
behaviour. You'll have to fix your script/program to catch that case
and avoid it.

Regards.
