From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] SIP/SDP conntrack and NAT helper
Date: Sun, 8 May 2005 22:58:21 +0200
Message-ID: <20050508205821.GE393@oknodo.bof.de>
References: <1115493770.1949.9.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
Content-Disposition: inline
In-Reply-To: <1115493770.1949.9.camel@www.l-chr.com.ar>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Christian,

> 	these patches adds conntrack and NAT support for SIP/SDP protocol.

Here's some critique based on a dumb scan through your patch.
I'm not competent to comment on the code content, right now.
So this mail only covers superficial, stylistic things.

First, there is user namespace pollution in
include/linux/netfilter_ipv4/ip_conntrack_sip.h
where you define two static inline functions str_search and get_lnlen.

Second, in the same file and elsewhere, get_info seems inappropriately
named for a kernel symbol. Also struct header_nfo.

+struct header_nfo headers[] = {
Ick! Sure that no other in-kernel code will ever declare a globally visible
symbol named 'headers'? What if Linus finds a use for this nice name? :)

[...] Could you stick to some common prefix for all visible symbols and macros
in include files / cross dependancies, please?

Hope this helps you along somehow.

I'll see how I can help in testing. Needs thinking. I don't use SIP regularly.

And please don't get this wrong. This mail is meant well :)

best regards
  Patrick
