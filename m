From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: quota.patch
Date: Fri, 11 Apr 2003 11:17:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304111112170.31394-100000@blackhole.kfki.hu>
References: <3E92EE00.7040703@linux.org.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>, <samj@samj.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: diegows <diegows@linux.org.ar>
In-Reply-To: <3E92EE00.7040703@linux.org.ar>
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

On Tue, 8 Apr 2003, diegows wrote:

> This is a modified quota match writing by Sam j. I add quota per ip and
> quota per connection (this is not very useful i think now...). Please
> try this and send  to me any comments and suggestions.

Sorry, I won't apply your changes in the present form

- userspace part is missing
- quota per connection - as you yourself write - is questionnable
- the patch itself is messy

Please re-work it before submitting again.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
