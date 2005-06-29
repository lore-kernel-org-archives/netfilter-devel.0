From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 29 Jun 2005 12:07:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506291158490.14974@blackhole.kfki.hu>
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

Hi,

On Wed, 29 Jun 2005, Roberto Nibali wrote:

> Verified. Another thing is the link to Guido's paper. For me this is not working
> anymore.

Yes, it disappeared. We'll add the article to the netfilter homepage
and refer to the new link in the sources - that's the best.

> > The last update sent to 2.6 kernel inclusion created the major difference
> > between the two flavours. Now they are in sync and the most important
> > fixes are in no particular order
>
> Awesome, thanks. For the record, we're talking about the following changes:
>
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/tcp-window-tracking/linux-2.4.patch?rev=4073&r1=4018&r2=4073

Yes, exactly.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
