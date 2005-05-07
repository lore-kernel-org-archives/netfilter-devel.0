From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [RFC] alternative to conntrack ID
Date: Sat, 07 May 2005 22:36:55 +0200
Message-ID: <427D26E7.8060701@ingate.com>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>
	<4278B23A.7050406@trash.net>	<4278B98E.7090707@ufomechanic.net>
	<427B8A46.8090006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <427B8A46.8090006@trash.net>
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

Patrick McHardy wrote:
> Amin Azez wrote:
> 
>>There isn't the problems of having to generate a unique id, or the worry
>>of it finally wrapping every few years as we don't pretend it is unique.
>>However, combined with either tuple it forms a unique id that wraps only
>>when the calendar does.
> 
> Wrapping is not a problem with a 64bit id. One thing I'm worried about
> with using a timestamp is that it might not be of high enough precision
> with very fast CPU and network to uniquely identify each connection.

You don't even need fast CPUs or networks to risk precision problems
- think multiple NICs and SMP.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
