From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Thu, 30 Jun 2005 09:48:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506300903350.16566@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
	<Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
	<20050629145545.GO26761@insomnia.benzedrine.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel Hartmeier <daniel@benzedrine.cx>
In-Reply-To: <20050629145545.GO26761@insomnia.benzedrine.cx>
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

Hi,

On Wed, 29 Jun 2005, Daniel Hartmeier wrote:

> The SACK handling looks curious to me. This is the TCP Selective
> Acknowledgements options, as in RFC 2018, right?

Yes, that's it.

> OpenBSD pf doesn't read those at all, currently. Stateful filtering
> shouldn't have to know about SACK, as SACK-enabled hosts must still
> honour the general rules in Guido's paper, i.e. ignoring SACK holes
> doesn't break any valid SACK-enabled connection. This is unlike the
> window scaling options, which the filter has to understand.
[..]

It just happens that senders send such segments which overlap the window
of the receiver, for example the right edge is actually out of window.
(That is in general a problem when an implementation follows Guido's paper
letter by letter.) And when SACK is enabled, there are holes, and such a
packet is received, the receiver notifies the sender about it in a SACK
option. As the holes are filled up, the receiver then sends a normal ACK
which acknowledges up to the highest right edge, which was actually out of
window. The whole SACK part takes into account that - it has nothing to do
with TCP normalization.

> advantages this has? We see no problems with SACK-enabled connections in
> pf, and simply ignore selective ACK options.

I suspect you haven't received reports on such problems because pf does
not log when it drops out of window segments. TCP is a robust protocol and
sometimes, by resending packets, it can overcome the situation and the
connection does not hang forever. However the window tracking patch for
netfilter lived very long time in patch-o-matic as an experimental
extension with logging out of window packets enabled. We received
complains and sometimes the reporters could supply both the logs and full
tcpdump recordings from the firewall which revealed the problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
