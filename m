From: Nils Ohlmeier <lists@ohlmeier.de>
Subject: Re: conntrack manipulation
Date: Sat, 10 May 2003 00:21:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305100021.24860.lists@ohlmeier.de>
References: <Pine.LNX.4.33.0305091431580.9035-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0305091431580.9035-100000@blackhole.kfki.hu>
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

On Friday 09 May 2003 14:36, Jozsef Kadlecsik wrote:
> On Thu, 8 May 2003, Nils Ohlmeier wrote:
> > phone1 ------ NAT ------- Internet ----- phone2
> >
> > Phone1 starts a call to phone2 (INVITE message). Phone2 confirms the call
> > (200 OK message) after the user picked up and starts to send RTP packets
> > to the public NAT address immediately. Now the comfirmation message hits
> > the SIP
>
> How can the user (phone1) send RTP packets before receiving the 200 OK
> message from phone2?

Not phone1 sends but phone2 sends RTP packets immediately after it send the 
'200 OK' to confirm that the user at phone2 picked up the hearer.
So the problem is basicly that the callee phone starts to send packets to fast 
(at least to fast for our solution).

It could also happen that that phone1 starts to send RTP packets before it 
received the '200 OK' if it received '183 Session progress' with a SDP body 
(which contains the IP and port of phone2). But this is not the normal case 
and makes no difference to the 200 case because we can insert the rules also 
on 183.

Greetings
  Nils Ohlmeier
