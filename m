From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] comment match port to pom-ng
Date: Tue, 18 May 2004 01:12:14 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405180110430.31252-100000@blackhole.kfki.hu>
References: <40A29A7D.A1111933@info-link.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <40A29A7D.A1111933@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 12 May 2004, Brad Fisher wrote:

> Attached is a tar file containing the comment match I wrote a while back
> (Also posted before for old POM with no response:
> http://marc.theaimsgroup.com/?l=netfilter-devel&m=107056927528485&w=2).
> I've ported it to pom-ng, and it should work for 2.4 kernels fine.
> Haven't tested 2.6 kernels, but will hopefully get a chance soon.

Patch is added to pom-ng. :-)
It is marked as for 2.4 only in the info file, because it won't work with
2.6 (API changed).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
