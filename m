From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 22 Jun 2005 19:23:20 +0200
Message-ID: <42B99E88.8090604@trash.net>
References: <424747E3.7000300@eurodev.net>
	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>	<4278B23A.7050406@trash.net>
	<4278B98E.7090707@ufomechanic.net>	<427B8A46.8090006@trash.net>
	<427D26E7.8060701@ingate.com>	<427D3EAF.3020200@trash.net>
	<427D41FA.5080506@ingate.com>	<1115648236.25627.17.camel@nienna.balabit>	<428A1807.8070708@ufomechanic.net>
	<428A5141.20901@trash.net>	<Pine.LNX.4.58.0505180948180.9582@blackhole.kfki.hu>	<42A23EDA.2090307@eurodev.net>
	<42A24F3B.8050607@eurodev.net>	<Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>	<42A83B96.4050302@eurodev.net>
	<42A83D72.1000106@eurodev.net>	<Pine.LNX.4.58.0506091519580.7610@blackhole.kfki.hu>	<42A9698F.30909@eurodev.net>	<Pine.LNX.4.58.050
	<Pine.LNX.4.62.0506140433070.4718@kaber.coreworks.de>
	<42B6E918.50
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42B92AE2.3070004@ufomechanic.net>
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

Amin Azez wrote:
> Err... the current problem is that the conntrack id _may_ be re-used
> within milli-seconds?
> I was trying to find a safe conntrack id.

No, it is 64 bit wide and does not wrap for a long time.

Regards
Patrick
