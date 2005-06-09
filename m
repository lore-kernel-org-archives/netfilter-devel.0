From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Thu, 09 Jun 2005 15:00:34 +0200
Message-ID: <42A83D72.1000106@eurodev.net>
References: <424747E3.7000300@eurodev.net>
	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>
	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>
	<4278B23A.7050406@trash.net>	<4278B98E.7090707@ufomechanic.net>
	<427B8A46.8090006@trash.net>	<427D26E7.8060701@ingate.com>
	<427D3EAF.3020200@trash.net>	<427D41FA.5080506@ingate.com>	<1115648236.25627.17.camel@nienna.balabit>	<428A1807.8070708@ufomechanic.net>
	<428A5141.20901@trash.net>	<Pine.LNX.4.58.0505180948180.9582@blackhole.kfki.hu>	<42A23EDA.2090307@eurodev.net>
	<42A24F3B.8050607@eurodev.net>	<Pine.LNX.4.58.0506061017330.16223@blackhole.kfki.hu>
	<42A83B96.4050302@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42A83B96.4050302@eurodev.net>
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

Pablo Neira wrote:
> All the things I've though so far are burned by something. The cleanest 
> way to do this looks the ID. Any other ideas?

Hm, this idea just came to my head. We could use a unsigned 8 bit
per-bucket-id that, together with the tuple, could uniquely identify a
conntrack (and make Patrick sleep with both eyes closed), reduce memory
comsumption (and make Jozsef happier) and fix my problem of the
conntrack table dumping (let Pablo drinks beer calmly).

Anything else?

--
Pablo
