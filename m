From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Sat, 15 Jan 2005 19:18:33 +0100
Message-ID: <1105813114.6266.9.camel@krak.odu>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
	<20050114082012.GA22042@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blachole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050114082012.GA22042@oknodo.bof.de>
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


  Hi,

2005-01-14, p keltezéssel 09.20-kor Patrick Schaaf ezt írta:
> I don't like sweep...

  I don't like it either. The dynamic timer management of Linux is quite
fast and efficient, so if we'd like to rely on our own timeout
management facility it won't be trivial either. (Although the 'sweep'
timer would run much less frequently of course, so it's not so clear...)

> This reminds me: what about my "timer management frequency reduction"
> from longtimeago? Basic points:

  If my memory serves me well, Jozsef made some tests using a similar
patch (or maybe yours?), but the results were quite controversial.
Jozsef?

-- 
  Krisztian Kovacs
