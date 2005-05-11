From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 11 May 2005 09:43:34 +0100
Message-ID: <4281C5B6.8010500@ufomechanic.net>
References: <424747E3.7000300@eurodev.net>	<42502F8D.5030504@trash.net>	<4254258E.5000204@eurodev.net>	<42627BC4.8070103@trash.net>	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>	<42789366.20702@ufomechanic.net>	<4278B23A.7050406@trash.net>	<4278B98E.7090707@ufomechanic.net>	<427B8A46.8090006@trash.net>
	<427D26E7.8060701@ingate.com> <427D3EAF.3020200@trash.net>
	<427D41FA.5080506@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <427D41FA.5080506@ingate.com>
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

I re-propose the possibility of using a serial number for conntracks as 
an "additional qualifer" (although also unique) to be used by user-space 
applications.
This way we keep the efficiency of using the tuple as a hash-key to 
retreive the conntrack, but the serial number to guard retreival of the 
right one.

I think that it is clear that although timestamp may sometimes be useful 
in a conntrack, it is does not universally solve the problem identifying 
a particular connection over short periods of time; and this because of 
the claim that it may be possible on some platforms to create and 
destroy and re-create a conntrack in the same tick.

UDP conntracks cannot be recreated in the same tick because their 
destruction is timer based, relating to a period of inactivity.

I think some cases where a TCP conntrack can be re-created in the same 
tick are where
1) SO_DONTLINGER/SO_REUSE_ADDR & friends are used on participating 
originating machines
2) Embedded and other weird network devices re-connect rapidly
3) A different MAC address takes over an IP address

Hacks to overcome this unlikely situation render the whole solution less 
attractive than a conntrack serial number.

User-space applications monitoring and manipulating conntracks do need a 
more permanent reference to a conntrack that is likely to remain unique 
over a timescale of at least a few minutes, so I re-propose a serial 
number to this end.

Amin
