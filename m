From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Mon, 17 May 2004 15:00:12 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405171427460.29543-100000@blackhole.kfki.hu>
References: <40A7FDB1.8080607@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40A7FDB1.8080607@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On Mon, 17 May 2004, Pablo Neira wrote:

> I'm having a look at your tcp-window-tracking patch, I made some
> modifications.

All efforts to sanitize and improve the patch is greatly appreciated!

> a) Use flags defined in tcp.h instead of bsd flags: I found that these
> flags are already defined in linux with different names in tcp.h, so we
> could use linux flags instead.

Fine, better to use the flags already defined in tcp.h.

> b) check that tcp is not malformed (doff has a faked value): I trust the
> value of skb->len, so we could use it to check that the doff is correct
> instead of that skb_copy_bits and that buff var, couldn't we?

No, I think we cannot avoid calling skb_copy_bits two times: first for the
minimal TCP header and secondly for the whole TCP header. In your patch
you trim the options off, by which we'd loose window scaling support.

> c) I replaced this:
[...]
> d) I think that we don't need this anymore, this is part of the old
> tracking:

No, we cannot do that: out of window TCP packets could result status
changes or to drop connections.

> e) I defined an inline __u32 segment_seq_plus_len instead a macro, it
> gives me more flexibility.

Yes, that's fine.

> f) Do you think that it's interesting adding fine grain locking in
> tcp-window-tracking?
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015166.html

First I was not quite convinced, but yes, I think it'd worth. However I
believe we should introduce a generic per data locking in ip_conntrack
instead of just a per TCP data locking. Thus there were no need the extra
per protocol-helper locks either.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
