From: "Stephan Jager" <Stephan@medz.org>
Subject: Re: H.323 conntrack patch
Date: Tue, 15 Jul 2003 15:00:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307151300.h6FD0AwT004469@alpha.medz.org>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: mzieba-netfilter@mail.biuro.medianet.pl
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hallo,

> > > OpenChannelAck. So... the gateway is trying to send your ,,voice'' to
> > > not mangled ip/port.
> > 
> > Thats right. I receive the "voice" stream on my linux box, which is then 
> > rejected with an icmp. But it IS going to the port from the h245 function 
> > which registered that expect_related.
> > 
> 
> Oh. Maybe that device, which you have, setup connection in slightly
> different way ;) ethereal with h323 plugin is nice ;-) But, this plugin
> is for win32 only, as I saw last time.
> On that cisco ata, I've got voice stream from box behind NAT, but no
> reply. Only one way.

my voicedevice does send voice "out" (I can hear it on the other side), 
but incoming voice isn't send to the voicedevice.

I've used ethereal with h323, so I know how the protocol goes.
I don't think the asn1 parsing is the problem, because it does find the 
correct ip/port for the voice connections in the h245 packets and it does 
register them with the expect_related function

Stephan
