From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 29 Jun 2005 12:26:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: daniel@benzedrine.cx, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42C26765.2060304@tac.ch>
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

On Wed, 29 Jun 2005, Roberto Nibali wrote:

> Daniel, I hope you don't mind that I've cc'd you out of the blue sky regarding
> this issue. However, I'd like you, if possible, to comment on the possible
> semantic differences between the window tracking implementation in OpenBSD pf
> (also based on the Guido paper) and the current netfilter one. The relevant
> patch on the netfilter part can be found at:
>
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/tcp-window-tracking/linux-2.4.patch?rev=4073&view=markup
>
> It would be nice to have a second opinion regarding the tcp state transitions,
> the SACK handling and the tcp_in_window() function, which is most critical.
> We're probably talking about this gem, among others:
>
> http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/sys/net/pf.c?rev=1.493&content-type=text/plain

I'd be just happy to receive any opinion, critics on how the window
tracking were implemented in netfilter.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
