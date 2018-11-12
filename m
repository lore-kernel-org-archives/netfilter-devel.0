From: Florian Westphal <fw@strlen.de>
Subject: Re: BUG: Fatal in exception in interrupt, at nf_conncount_count
 [regression in 4.19(.1)]
Date: Mon, 12 Nov 2018 15:10:45 +0100
Message-ID: <20181112141045.3fhxzgv5c7nu2stp@breakpoint.cc>
References: <20181112150406.1bbb7bee@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Yi-Hung Wei <yihung.wei@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Bruno =?iso-8859-15?Q?Pr=E9mont?= <bonbons@sysophe.eu>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181112150406.1bbb7bee@pluto.restena.lu>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Bruno Prémont <bonbons@sysophe.eu> wrote:
> Hi,
> 
> With linux-4.19.1 I'm seeing regular kernel panics since this night
> with uptime of 5 to 30 minutes in between. System is not heavily loaded.
[..]

> It looks like those locking related changes may be the cause.

Yes.

> Bisecting it will be hard as I don't have exact packet stream

No need.  Can you give these three patches a try?

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=73972
