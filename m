From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack manipulation
Date: Mon, 12 May 2003 09:35:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305120933420.2472-100000@blackhole.kfki.hu>
References: <200305100021.24860.lists@ohlmeier.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nils Ohlmeier <lists@ohlmeier.de>
In-Reply-To: <200305100021.24860.lists@ohlmeier.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 10 May 2003, Nils Ohlmeier wrote:

> On Friday 09 May 2003 14:36, Jozsef Kadlecsik wrote:
> > On Thu, 8 May 2003, Nils Ohlmeier wrote:
> > > phone1 ------ NAT ------- Internet ----- phone2
> > >
> > > Phone1 starts a call to phone2 (INVITE message). Phone2 confirms the call
> > > (200 OK message) after the user picked up and starts to send RTP packets
> > > to the public NAT address immediately. Now the comfirmation message hits
> > > the SIP
> >
> > How can the user (phone1) send RTP packets before receiving the 200 OK
> > message from phone2?
>
> Not phone1 sends but phone2 sends RTP packets immediately after it send the
> '200 OK' to confirm that the user at phone2 picked up the hearer.
> So the problem is basicly that the callee phone starts to send packets to fast
> (at least to fast for our solution).

Then enter the required rules when phone1 sends the command, without
waiting for a confirmation from phone2. If phone2 would refuse the
request, then delete the unnecessarily added rules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
