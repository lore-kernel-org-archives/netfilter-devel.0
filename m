From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [CTNETLINK] Rework conntrack fields dumping logic on events
Date: Thu, 23 Nov 2006 14:46:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611231440070.18293@blackhole.kfki.hu>
References: <4553D3D5.40408@netfilter.org>
	<Pine.LNX.4.64.0611102151300.26087@blackhole.kfki.hu>
	<4557B157.6010205@netfilter.org>
	<Pine.LNX.4.64.0611142055130.1650@blackhole.kfki.hu>
	<45659FBA.2020505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45659FBA.2020505@trash.net>
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

Hi Patrick,

On Thu, 23 Nov 2006, Patrick McHardy wrote:

> > The attached patch (on top of Patrick's nf_nat git tree and my patches 
> > sent to this list) implements what I suggested: *do* register the helpers 
> > which are actually assigned by an expectfn. Thus ctnetlink can find them 
> > by name and then fill conntrack with the helper. In order to make sure a 
> > bogus packet can't trigger such helpers, __nf_ct_helper_find had to be 
> > modified. What do you think?
> 
> This is something needed for userspace-helpers (Harald did some work
> in this direction), but I can't really think of what it could be used
> for currently.

It is required at conntrack replication if/when the H.323 helper is in 
use. The H.245 helper is currently not registered so there is no 
way to replicate the helper: the name is passed but the other side is 
unable to find the helper on the list of the registered helpers.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
