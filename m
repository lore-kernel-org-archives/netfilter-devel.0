From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] update raw patch in POM [2.4.x]
Date: Wed, 22 Jun 2005 11:19:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506221113530.5684@blackhole.kfki.hu>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
	<20050621003441.GI8335@postel.suug.ch>
	<42B76474.8080209@eurodev.net> <20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net> <42B82177.5010101@tac.ch>
	<42B8288C.9030004@trash.net> <42B82F29.40307@tac.ch>
	<Pine.LNX.4.58.0506220859360.5627@blackhole.kfki.hu>
	<42B92B0A.2000802@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42B92B0A.2000802@tac.ch>
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

On Wed, 22 Jun 2005, Roberto Nibali wrote:

> > Are you running a recent kernel from the 2.6 tree? A lot of improvements
> > had been submitted in in spring and since then I have practically not
> > received any reports on window tracking problems.
>
> I'm not running a 2.6.x kernel for the reasons explained below:
[..]

Then best thing is to backport the changes. Actually, Krisztian did it
once but that was in the mid of the changes and therefore was never
committed in svn.

OK, I'll do it and report back when it can be downloaded from svn.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
