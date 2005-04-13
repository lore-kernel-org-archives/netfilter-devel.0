From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 09:03:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
	<20050413065248.GB16534@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050413065248.GB16534@oknodo.bof.de>
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

On Wed, 13 Apr 2005, Patrick Schaaf wrote:

> Also see my other mail: I think that all this is too complicated and
> too restrictive on the admin of the machine, and should simply NOT
> be done. The "more interesting" problem above, seems to confirm
> this feeling :)

I absolutely agree.

Rule evaluation should be improved by replacing the current linear
algorithm with some tree-based solution like nf-hipac. Or even with a tree
of internal IP sets ;-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
