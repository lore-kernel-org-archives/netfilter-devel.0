From: Francisco Javier Cabello Torres <fjcabello@visual-tools.com>
Subject: Re: http&rtsp kernel 'proxy'
Date: Fri, 3 Oct 2003 09:00:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310030900.31886.fjcabello@visual-tools.com>
References: <200310021145.10243.fjcabello@visual-tools.com> <1268892368.20031002141507@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1268892368.20031002141507@habitat-b.de>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
thanks for all replies.
After all I think it's impossible to do it with netfilter. The problem, as Don 
Cohen told me, it's that I don't know which server owns the connection with 
the first packet (SYN). I need to establish the connection and then choose 
one of the target servers... this should be at application level.

Don Cohen reply:
'You do need a proxy for this, it cannot be done in netfilter, and in
general almost certainly should not be done in the kernel.
The problem is that you have to establish the connection before you
can find out which server to use.  If you could tell on the basis
of the first packet then you'd be in good shape.  Normally this would
be possible cause the first packet (SYN) would specify a different
port for the two servers.  But since this is not the case for you,
the first packet does not determine the server.  Therefore you must
complete the connection with a proxy, and then have that proxy, after
it decides which server to use, open a new connection to that server.
And as long as you have a proxy listening to all the packets that
come in, you don't need to use netfilter - just parse the packets in
the proxy.'

Regards,

Paco.



On Thursday 02 October 2003 14:15, DarKRaveR wrote:
> Hello Francisco,
>
> I don't know about rtsp, but consider this:
>
> HTTP should not be a problem, since the server is just answering, or
> to put it in other words: As soon as the server establishes a
> connection, the client will start the 'communication'. So it should be
> possible to to analyse, what the client wants. If for rtsp the order
> is reversed, like for smtp or most other protocols, your plans are
> impossible. If, in both cases, the client initiates the protocol, I
> assume you plans can succeed, at least I don'T see any reason, why it
> shouldn't work.
>
> Thursday, October 2, 2003, 11:45:10 AM, you wrote:
>
> FJCT> Hello,
> FJCT> I'm new with kernel development.
> FJCT> I would like to implement a http&rtsp port as a kernel module.
> FJCT> First, I will try to explain what I want to develop. I have two
> servers, one FJCT> of then a HTTP server, listening on port 80, and the
> second one a RTSP FJCT> server, listening on port 554. My system is besides
> a firewall which only FJCT> allow traffic in port 80. Because of that I
> need a 'proxy' listen on port 80 FJCT> which redirect traffic to RTSP
> server (still listen on 554) or HTTP server FJCT> (now listen on 8080).
> This 'proxy' should  analyze incoming packets and FJCT> depending of
> contents redirect it to one of the servers.  If packet contents FJCT>
> belongs to rtsp protocol, it will be redirect to port 554, however if it's
> a FJCT> http packet, it will be redirect to 8080.
>
> FJCT> I have been reading some documentation, and it think it would be
> possible to FJCT> implement a iptables 'match' for rtsp and http packets,
> modify iptables to FJCT> accept new match and then, with my modified
> iptables, specify rules to send FJCT> packets to correct servers.
> FJCT> Any ideas? Am I going crazy?  ;)
>
> FJCT> Thanks.
>
> FJCT> Paco
>
> FJCT> --
> FJCT> Stop software patents!
> FJCT> examples: http://www.base.com/software-patents/examples.html
> FJCT> stop it, see http://petition.eurolinux.org &
> http://petition.ffii.org/eubsa/en
>
> FJCT>  11:44:07 up 1 day, 19:11,  1 user,  load average: 0.09, 0.07, 0.04

-- 
------------------------------------------------------
V I S U A L   T O O L S
Francisco Javier Cabello Torres
R&D Department / Departamento de I+D
C/Isla Graciosa, 1.
28034 Madrid - Spain 
Telephone: +34 91 72948 44
Fax:  +34 91 358 52 36
fjcabello@visual-tools.com 
------------------------------------------------------
Stop software patents!
examples: http://www.base.com/software-patents/examples.html
stop it, see http://petition.eurolinux.org & http://petition.ffii.org/eubsa/en

 08:53:44 up 54 min,  2 users,  load average: 1.98, 2.23, 1.47
