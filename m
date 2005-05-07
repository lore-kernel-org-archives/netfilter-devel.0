From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Sun, 08 May 2005 00:18:23 +0200
Message-ID: <427D3EAF.3020200@trash.net>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>
	<4278B23A.7050406@trash.net>	<4278B98E.7090707@ufomechanic.net>
	<427B8A46.8090006@trash.net> <427D26E7.8060701@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <427D26E7.8060701@ingate.com>
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

Marcus Sundberg wrote:
> You don't even need fast CPUs or networks to risk precision problems
> - think multiple NICs and SMP.

SMP or multiple NIcs don't matter because at any point in time only
one instance of a connection can exist. The challenge is to have a
unique identifier over time.

Regards
Patrick
