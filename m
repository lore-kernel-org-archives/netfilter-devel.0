From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp-window-tracking for 2.6? (Re: [PATCH] patch-o-matic-ng
 reorganization and updated patches)
Date: Mon, 23 Feb 2004 09:45:53 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402230942390.19701-100000@blackhole.kfki.hu>
References: <029801c3f7a3$ee1920e0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nuutti Kotivuori <naked@iki.fi>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrew Hall <temp02@bluereef.com.au>
In-Reply-To: <029801c3f7a3$ee1920e0$2601010a@bluereef.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004, Andrew Hall wrote:

> There seems to be a dependancy on nf_log for the tcp-windowing patch? Using
> the latest CVS patch-o-matic and 2.6, the nf_log patch seems to fail ( says
> it's missing one needed file). Is this intentional or should we expect the
> 2.6 nf_log+tcp-windowing patches to install cleanly now?

The logging part from the TCP window tracking patch was ripped off,
because there is now a commong logging ifrastructure (nf-log). Thus the
dependency is unavoidable.

The 2.6 nf-log patch fails from pom-ng? Then I have to double check it
again. Thank you for notifying about the problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
