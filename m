From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ip_conntrack-timeouts conflicts with tcp-window-tracking
Date: Mon, 28 Oct 2002 12:29:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210281225160.1385-100000@blackhole.kfki.hu>
References: <20021025203433.GJ23228@pc.ilinx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter@interlinx.bc.ca>
In-Reply-To: <20021025203433.GJ23228@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Oct 2002 netfilter@interlinx.bc.ca wrote:

> Which should I prefer, or should I merge them by taking the bulk of
> the tcp-window-tracking patch and replace the references to timeout
> constants with the sysctl controlled timeout values that
> ip_conntrack-timeouts provides?
[...]
> I sure like the idea of the tcp window tracking patch and would like it,
> but I also like being able to control timeouts via sysctl rather than
> having to use defined constants.

The tcp-window-tracking patch do provide sysctl control of all the timeout
parameters. Please read the help file.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
