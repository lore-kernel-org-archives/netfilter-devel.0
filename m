From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ASN.1 decoder for h323-conntrack-nat
Date: Thu, 16 Oct 2003 15:42:43 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310161528160.4832-100000@blackhole.kfki.hu>
References: <3F8E9C32.1050609@yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Nasonov <alnsn-mycop@yandex.ru>
In-Reply-To: <3F8E9C32.1050609@yandex.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Oct 2003, Alexander Nasonov wrote:

> Sorry, I don't have enough time right now to understand how current
> version of h323-conntrack-nat works. Probably, what I'm going to
> announce here is already implemented.

No, not at all. The current code simply assumes that if we find the IP
address of the sender in the payload, then the next bytes give the port
we are looking for. :-| Naturally this brute force method can fail very
easily and does not support a few features of H.323.

> Anyway, here is what I have. I've implemented callback-based decoder of
> ASN.1 PER rules. With a help of this decoder it's possible to analyze
> H323 packet and to call user-defined function when the code came across
> an interesting type. For example, it's easy to jump from fastStart
> element to OpenLogicalChannel or to detect OpenLogicalChannel ->
> reverseLogicalChannelParameters -> mediaChannel -> ipAddress sequence.
> Generated code doesn't have dynamic memory allocations and other
> undeterministic stuff. It just easts bits :))) In it's current state the
> code is ugly (due to deadline) and it is C++. If there is an interest, I
> can rewrite it later.

That would be great! We cannot use code written in C++.

[Actually, I have just discovered that the source code of the most recent
ethereal contains ASN.1 PER/H225/H245 decoders written in C.]

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
