From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ASN.1 parsing for H.323
Date: Mon, 16 Jun 2003 11:53:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0306161144540.21960-100000@blackhole.kfki.hu>
References: <3EED87B2.90809@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <3EED87B2.90809@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 16 Jun 2003, Philip Craig wrote:

> I've seen a few messages in the list archives about the current
> H.323 being a brute force approach, and that a better implementation
> would be to do ASN.1 parsing.

Yes.

> Is ASN.1 parsing in the kernel still the desired approach?  I saw
> some messages from Sampsa Ranta in 2001 where he concluded that it
> was not suited for in the kernel and that it would be better in
> user space.  I think his primary reason was the need to parse the
> stream, rather than individual packets.

In my opinion because for H.323 there'd be need a minimal ASN.1 PER
decoder "only", it'd worth to do it in-kernel.

> Has anyone else done any work on this yet?

No time :-(.

> If this is a worthwhile endeavour I may start some work on it.

I'd definitely be good if someone had time to work on such a project.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
