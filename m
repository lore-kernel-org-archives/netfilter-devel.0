From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: conntrack manipulation
Date: Tue, 13 May 2003 09:35:49 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305122335.h4CNZpL24181@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Nils Ohlmeier" <lists@ohlmeier.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Howdy,

  How, then, does  this differ from either the FTP conntrack+nat 
module?  Surely you just want to right a small connection tracker
that understands your phone protocol and relays connections
appropriately?



----- Original Message -----
>From: "Nils Ohlmeier" <lists@ohlmeier.de>
>To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
>Subject:  Re: conntrack manipulation
>Date: Mon, 12 May 2003 20:15:02 +0200
>
> Hi Jozsef,
> 
> first of all thanks for thought and ideas.
> 
> On Monday 12 May 2003 09:35, Jozsef Kadlecsik wrote:
> > On Sat, 10 May 2003, Nils Ohlmeier wrote:
> > > Not phone1 sends but phone2 sends RTP packets immediately after it send
> > > the '200 OK' to confirm that the user at phone2 picked up the hearer. So
> > > the problem is basicly that the callee phone starts to send packets to
> > > fast (at least to fast for our solution).
> >
> > Then enter the required rules when phone1 sends the command, without
> > waiting for a confirmation from phone2. If phone2 would refuse the
> > request, then delete the unnecessarily added rules.
> 
> For a call from internal to external (outbound) this would be possible if we 
> insert DNAT rules with any source IP and port. But for inbound calls we have 
> a problem, because with the SIP protocol you do not know the final 
> destination (IP and port) if you see a traversing INVITE. So we can insert 
> the DNAT rule only after we saw the SDP part of the 200 OK (or any other 1xx 
> with a SDP body).
> 
> Regards
>   Nils Ohlmeier
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
