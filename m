From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] make multiple invocations of do_command() behave sane
Date: Tue, 3 Feb 2004 00:04:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402030000460.16625-100000@filer.marasystems.com>
References: <1075748474.19762.51.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1075748474.19762.51.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2 Feb 2004, Martin Josefsson wrote:

> I wondered the same when I found the problem. I thought that someone
> must have noticed it before.

Personally I am ashame for not having noticed this slight problem with 
iptables-restore. Have been using it since years back. But then we always 
have the same order of our matches so it is not that strangewe haven't 
noticed.

> Since noone's screamed yet I'll merge it later today in order to give it
> wider testing, maybe then someone screams.

Please do. Will try it out tomorrow.

Regards
Henrik
