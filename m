From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Thinking about REJECT
Date: Fri, 11 Apr 2003 11:10:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304111056340.31394-100000@blackhole.kfki.hu>
References: <3E8B7012.1060607@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <3E8B7012.1060607@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Thu, 3 Apr 2003, Martijn Lievaart wrote:

> Looking at the icmp type 3 code 13 discussion, the fake source patch
> (does anyone use that?) and my own experiences, I would like to propose
> an alternative to REJECT. As I see it, there are several problems with
> the current REJECT target:
>
> - Not all icmp codes are supported

:-) That is the problem we have to solve.

> - Current code does not look at the packet it is rejecting, so it always
> sends a port unreachable. This is not RFC complient. F.i. tcp
> connections should be rejected with a tcp reset, unknown protocols may
> be rejected with a protocol unreachable.

It's up to the firewall administrator how he/she wishes to refuse given
packets. The default can be argued - but others might prefer ICMP
Administrative Prohibited instead.

> - The kernel-userspace interface does not allow any changes

I don't understand what do you mean here.

We have had several (!) threads on the subject and explored a couple of
possible solutions, keeping the functionality in the original module.

I'm going to accept Maciej's simple and straightforward solution for the
problem: implement the missing ICMP error message in REJECT without any
ado and add an INCOMPATIBILITY section to the documentation.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
