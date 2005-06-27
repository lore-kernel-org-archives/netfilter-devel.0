From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: RSH helper concurrent sessions fix
Date: Mon, 27 Jun 2005 16:09:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506271557380.11307@blackhole.kfki.hu>
References: <JBEOIOMFMBOPMPLFDIALIEAACKAA.aberle@infotech.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sebastian Aberle <aberle@infotech.de>
In-Reply-To: <JBEOIOMFMBOPMPLFDIALIEAACKAA.aberle@infotech.de>
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

On Mon, 27 Jun 2005, Sebastian Aberle wrote:

> I'll try to clarify my view of things:
>
> The unpatched helper created an expectation with a dport mask of 0xfc00,
> meaning any unprivileged port matches. In my case, I run an automated machine
> status report generator that uses RSH to gather data from some machines,
> like disk, memory and CPU usage etc. This script creates several parallel
> RSH sessions at a quite fast interval, and that obviously confused the
> connection tracker in a way that it "uses" the wrong expectation for some
> incoming error channel connections, resulting in dropping these packets.
> Creating one connection after another always worked flawlessly.
>
> Now after my patch, the expectations are created for exactly the one port
> that was chosen in the first connection (mask 0xffff). That seems to help
> the connection tracker to find the right expectation for each RSH session.

I see, sorry for my confusion. I applied your patch in svn with one slight
addition: in linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c
exp->mask.dst.protonum was set in the original file to 0xff instead of
0xffff.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
