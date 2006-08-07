From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset matches either,both
Date: Mon, 7 Aug 2006 09:41:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0608070907400.8741@blackhole.kfki.hu>
References: <eat75p$9o4$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <eat75p$9o4$1@sea.gmane.org>
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

On Thu, 3 Aug 2006, Amin Azez wrote:

> These patches to ipset allow "either" and "both" to be specified as well
> as "src" and "dst".

I'm a bit surprised because "either" can naturally be expressed by two
iptables rules and "both" is equivalent with two set matches:

iptables ... -m set --set foo src -m set --set foo dst

Why do you need "both" and "either" encoded internally in ipset?

> I considered doing this as a hack in ip_set.c, by calling the match
> twice, faking flags of SRC and DST, but it was a hack and wouldn't
> easily cover the porthash which consumes two flags.
>
> Instead I've altered the test of all of the set types, to accept BOTH
> and EITHER as well.

But thus all the extensions (set types) have to know what "both" and
"either" means, which'd belong to the ipset core as I believe, if
introduced.

> The encoding of BOTH and EITHER was troublesome as flags is a mix of an
> enum and bitmap-set; what I did isn't clean, but it will do, and doesn't
> break user-space compatability.

That is nice! I tend to break backward-compatibility too lightheartedly
:-(.

> I've tested the behaviour of src dst either and both for iphash.
> I'm not sure about ipportmap because the man pages aren't clear how to
> write rules for this.

In order to match both dst IP and dst port (for example all publicly
available servers behind a firewall) one can use an ipportmap type of set
and a single rule like this:

iptables ... -m set --set foo dst,dst

> I'm not sure of the effect on this with bindings; I suspect that with
> either,both we may want a preferred test order, and the one that matches
> first is used to follow bindings.

(Unless someone convinces me that bindings are really great and should
deserve to outlast) I think bindings are a dead-end: internally not
efficient enough and hard to understand by the users.

Pablo and I started to rewrite ipset using netlink as kernel/userspace
communication interface in the spring and thrown out bindings as
unnecessary baggage. Unfortunately I have been overburdened since then and
will only be able to pick up and continue the work in October :-(. But
that gives a wide window for new ideas in ipset(/nfset) :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
