From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [NETFILTER 00/05]: updated nf_nat patch
Date: Fri, 3 Nov 2006 21:46:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611032108090.16098@blackhole.kfki.hu>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
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

On Fri, 3 Nov 2006, Patrick McHardy wrote:

> I've updated your nf_nat patch to apply on top of Martin's patches
> (on top of the current git tree) and merged the changes we had in
> IPv4 NAT since then.

Simply great!
 
> I've also reviewed the patch a bit, the main problem I found so
> far is the nf_conntrack allocation scheme, which requires all
> features to be known at creation time, so it doesn't allow
> nf_conntrack_alter_reply to assign a helper to a connection
> that previously didn't have one (same problem for helpers
> like H.323 which manually assign helpers in their expectfns).

Yes, that's a problem. I believe it can be solved by re-arranging the 
instructions in init_conntrack and changing expectfn itself/adding a new 
glue function.
 
> Other than that it seems (and works) fine so far, if we find
> a good solution for the helper problem I would like to merge
> this as fast as possible if you don't have any objections.

Nothing against it at all. But the other helpers besides the ported FTP 
one are missing too. I'll look into it, because that can uncover other
unresolved issues.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
