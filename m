From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH-2.4-POM] sessions stuck in CLOSE_WAIT state
Date: Thu, 9 Oct 2003 09:01:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310090854360.22077-100000@blackhole.kfki.hu>
References: <20031008094447.GL25743@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Willy Tarreau <willy@w.ods.org>, <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031008094447.GL25743@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 8 Oct 2003, Harald Welte wrote:

> On Wed, Oct 08, 2003 at 12:18:17AM +0200, Willy Tarreau wrote:
> > Fortunately, tcpdump showed to me that all stuck sessions had in common the
> > fact that the server aborted them with an RST after the first FIN+ACK, so
> > in CLOSE_WAIT. Others which were aborted with an RST just before or just after
> > were destroyed without any problem.
>
> Ok, this sounds like a pretty clear case than.  This bug has not been
> found because replying with RST afer FIN+ACK seems a quite unusual
> pattern.
>
> > /*rst*/ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sLA, sLI },
> >
> > But the tcp_window_tracking patch changes this behaviour, I think because of
> > a typo, since I see no other reason not to terminate a session upon RST :
> >
> > /*          sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI   */
> > /*rst*/   { sIV, sCL, sCL, sCL, sCL, sIV, sCL, sCL, sCL, sIV },
>
> yes, I totally agree with you.  I'll apply your proposed patch to
> patch-o-matic.  If Jozsef disagrees, he can revert that change.

I agree completely.

> > BTW, is it normal that an RST received in TIME_WAIT state terminates the
> > session ? I would have thought that we should keep it in TIME_WAIT anyway.
>
> again agreed.  Jozsef, what do you think?

It's normal, but highly unusual I think. (Were it an "optimization" of TCP?)

Thank you very much the nice analysis and report.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
