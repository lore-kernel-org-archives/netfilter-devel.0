From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Thu, 30 Jun 2005 09:51:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506300948290.16566@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C2AE97.7020305@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42C2AE97.7020305@tac.ch>
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

> > found in the patch-o-matic-ng svn repository. The 2.4 version of the
> > nf-log patch (which is required) has been updated as well.
>
> The updated nf-log patch seems to be missing the neccessary symbol exports.
> Please consider adding this to your linux-2.4 patch:

I mixed up something then, I have even committed the patch in svn by
running the patched kernel. Sorry, expect fixed patch tomorrow.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
