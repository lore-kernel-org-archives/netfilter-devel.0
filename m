From: Cedric de Launois <delaunois@info.ucl.ac.be>
Subject: Re: Transparent broadband network connectivity (IP PnP)
Date: 17 Mar 2003 18:14:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1047921257.24198.111.camel@descartes.info.ucl.ac.be>
References: <200303132244.h2DMisD16238@singularity.tronunltd.com>
	 <200303132244.h2DMisD16238@singularity.tronunltd.com>
	 <5.2.0.9.2.20030317205113.022da110@192.168.1.1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Duke <johnyduke@yahoo.com>
In-Reply-To: <5.2.0.9.2.20030317205113.022da110@192.168.1.1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Then the wierd thing happened. When client send a DNS request, the repl=
ied
> SYN/ACK from Public DNS server to gateway box, after go into eth1
> interface, seems to be disappeared in the kernel. I can not see either =
that
> SYN/ACK packet send out to internal network via eth0 (in correct routin=
g
> case) or outside network via eth1 (in wrong routing case). For sure tha=
t if
> i remove (2) rule, I can see the SYN/ACK packet after de-nat'd send out
> again to eth1. It seems to me that ROUTE target has some weird side eff=
ect.

Could you please use the latest CVS version and activate the debug mode
for the ROUTE patch ? Just replace in file ipt_ROUTE.c, line 23 :
   #if 0
with=20
   #if 1
to activate the debug mode.

You'll be able to see in the kernel logs why the ROUTE target drops the
packets.

I suspect packets are dropped because it can't guess the right hardware
address for your client. It will probably need a fix.

C=E9dric
