From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset problems
Date: Wed, 12 Jan 2005 12:32:37 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501121230090.31784@blackhole.kfki.hu>
References: <20050112112220.GA19503@fouk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@fouk.org>
In-Reply-To: <20050112112220.GA19503@fouk.org>
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

On Wed, 12 Jan 2005, Piotr Chytla wrote:

> IP sets from pom-ng fail to compile with 2.4.28 kernel,
[...]
> I've attached patch for this, maybe it would be useful for someone.

Yes, good catch. I'm working on a new release which includes this fix and
a new maptype to store CIDR blocks.

Thank you for the report and bugfix.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
