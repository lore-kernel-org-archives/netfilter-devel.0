From: Davide Guerri <tato.net@tin.it>
Subject: Re: nf_conntrack
Date: Mon, 1 Mar 2004 12:08:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403011208.28184.tato.net@tin.it>
References: <200402221110.28339.tato.net@tin.it> <200402261320.08113.tatonet@tiscali.it> <200403010608.PAA13782@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200403010608.PAA13782@toshiba.co.jp>
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

Hi Yasuyuki,

On Monday 01 March 2004 07:08, you wrote:
> Hi, Davide,
>
> Sorry for late replying.

Don't worry, thank you very much for your reply ;)

> > > Sorry, I'm confusing. Which path should packets go through ? we need to
> > > design so that users can filter/log packets before and/or after
> > > translating. At least, translated packets should go through
> > > NF_IP{6}_FORWARD, I think.
> >
> > I agree with you, users should be able to filter/log NAT(P)T-PT'ed
> > packets. However there are some (bad) problems.
> > At present time your conntrack code doesn't handle IPv6 fragments, but I
> > guess that when it will do, IPv6 datagrams will be defragmented as in
> > current conntrack. So I assume that NA(P)T-PT code will see only entire
> > l3 packets.
>
> Yes. That is missing piece. Of cause, I'll implement that. But I haven't
> decide how to handle fragmented IPv6 packets yet.
>
> ip6_conntrack, which is written by me and tracks only IPv6 packets, clone
> fragmented packets and reassemble them (note: not linearize). After
> tracking, reassembled packet is discard and pass original fragmented
> packets to next network process. Of cause, original fragmented skbs points
> to same conntrack.
>
> I adopted this way to prevent from disturbing other IPv6 codes(ex. Path MTU
> Discovery.)
>
> But I don't know this is best. Maybe NA(P)T-PT helper module wants
> reassembled packet to rewrite data in payload (ex FTP).

Yes, that is a good way, but there is another issue. Since conntrack will be 
used to implement a statefull IPv6 filtering, we need to be sure that what is 
received by destination host is what the firewall have seen. 
I know that partially overlapped IPv6 fragments should never appear (since 
only the source host can perform fragmentation), but in general we don't know 
if the destination host will accept or discard them.
If the firewall lets them pass, we couldn't be sure of the order in which they 
will be received by the destination ( think, for instance, to the well-known 
IPv4 overlapped fragments attack).

Personally I think that a firewall must discard overlapped (IPv4/IPv6) 
fragments, but this is only my personal point of view.

> > One problem is that I should know if original datagrams had a fragment
> > header or not. NA(P)T-PT should produce IPv4 packets with DF flag set for
> > IPv6 non-fragment datagrams and IPv4 packets with DF not set for IPv6
> > datagrams with a fragment header. So, although on one hand I need
> > conntrack, on the other hand I should see original datagrams.
> > A similar problem turns out on IPv4-to-IPv6 translation. When I receive
> > IPv4 datagrams with DF not set, I should fragment them so that their IPv6
> > translation fits in 1280 octects. If DF flag is set, in order to allow
> > pathMTU discovery, I should preserve their size and I should translate
> > them into IPv6 datagram without a fragmentation header (except for IPv4
> > fragments with DF set...).
> > I'm trying to say (with my terrible English) that a NA(P)T-PT
> > implementation should have more control over IPv6/IPv4 packets: since
> > conntrack defragments/fragments them it's impossible to be RFC 2766
> > compliant.
>
> IPv4 header has DF bit field and it's not changed. so there is no problem
> even if reassembled by conntrack in the case of IPv4-to-IPv6.

Actually ip_conntrack ignore DF flag in fragmented IPv4 fragments. 
This leads to a problem described in this bug report:
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=48
In this report I've proposed a solution; however I must admit that the 
implementation I've proposed it is not good. (However I don't know if that 
idea can be useful for you).
I think we must avoid that problem in IPv6 connection tracking since in this 
case the consequences are more serious.

> There is problem in the case of IPv6-to-IPv4. I was going to implement so
> that nf_conntrack removes Fragment Header in the case that payload length
> of reassembled packet is > 65535 - 8 .
>
> ok, I need to be more care about handling fragmented packet.

If there were no problems it wouldn't be amusing! ;))

> But in any case, original(not reassembled) IPv6 packets are needed to be
> passed next network.
> And I think it's natural that behavior for IPv4 and IPv6 is synchronized.
> This mean that IPv4 packets isn't reassembled.
>
> In this case, benefits are
> 	- all modules can process fragmented packets with any style.
> 	- all modules can prevent from disturbing other network code.
>
> drawbacks are
> 	- User Interface will be changed. current ip_conntrack reassemble at
> 	  PRE_ROUTING, and refragment at POST_ROUTING. so users assume that
> 	  packets are reassembled when filtering.
>
> 	- if multiple module want reassembled packets, reassembling is occurred
> 	  many times.
>
> The 1st drawback can be solved at ip{6}_tables in kernel.
> But I don't any idea about 2nd issue in now.

I agree with you, IPv6 and IPv4 conntrack behaviours should be synchronized.
This is an hard issue: any solutions will require many changes in present 
netfilter modules...

> > For these reasons I'm tempted to use the approach proposed by Henrik
> > (virtual network device).
>
> I have timely news. Recently, I heard that kernel implementation of NAT-PT
> is already created. Maybe this implementation doesn't use netfilter.
> virtual device ???
>
> I'll attach the message at usagi-users ML.

Thank you very much. I've also noticed another NA(P)T-PT implementation in the 
Linux kernel (http://naptpt.sourceforge.net/). However this implementation 
doesn't handle fragment (both for IPv4 and IPv6), and use a poor connection 
tracking for TCP based on activity instead of the state: it removes a TCP 
connection from tracked connections if there is no activity for a certain 
period of time (this is good for UDP and ICMP but not for TCP).
Moreover this implementation bypasses all netfilter code (it intercepts 
packets in PRE_ROUTING and uses ip_output() to send translated packets).

I'm really in trouble: I have got the code for the tranlation, I have got a 
precise idea of how to translate packets (even in case of fragmentation) but 
I can't decide where to translate... ;))

Best regards,
Davide Guerri.

-- 
T@1t
