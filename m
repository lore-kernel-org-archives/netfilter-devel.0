From: "Ethy H. Brito" <ethy.brito@inexo.com.br>
Subject: Re: netfilter observation
Date: Fri, 27 Jan 2006 08:49:37 -0200
Message-ID: <20060127084937.432199b1@pulsar.inexo.com.br>
References: <20060126171057.7fb9632d.ethy.brito@inexo.com.br>
	<20060127061433.GA31447@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20060127061433.GA31447@oknodo.bof.de>
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

On Fri, 27 Jan 2006 07:14:33 +0100
Patrick Schaaf <bof@bof.de> wrote:

> Hello Ethy,
> 
> to make a short answer to a long (and well-formulated) question:
> 
> > Is this the expect behavior?
> 
> Yes. Not only expected, but desired, and relied upon in many many
> real world setups. 

I've already suspected that. This could not have passed hidden that long.

> conntracking/NAT and table processing are as
> independant as can be. 

And this must be this way, I think. I will use some external tool to make things happen.
Someone told me about Cutter (a TCP FIN-ACK-RST tool).

> In the filter table, matches like '-m conntrack' can be used to
> refer to the NAT state of the packet under inspection.

I can't see how this could help me. The old data stream has already its state set
to ESTABLISHED.

> > How to "kill" the old data flow?
> 
> per-flow: simulate a suitable TCP RST, or use one of the new style
> userlevel conntrack manipulation tools (work in progress, as far
> as I know)

Could you gimme some pointer about these tools? They are not in trunk/conntrack
tree and google was not of much help (too much garbage to dig into).

> best regards
>   Patrick

Best Regards

Ethy
