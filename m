From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 09:17:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
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

On Mon, 20 Oct 2003, Henrik Nordstrom wrote:

> a) Assign a globally unique ID to each conntrack, in such manner that IDs
> is not reused for a significant amount of time. This to provide a stable
> point of reference to a connection with low risk of false collisions if
> the original connection was destroyed while userspace still thought it was
> there.

I still don't see why can't we simply use the tuple as unique id, as
Harald suggested. That's truly unique and does not require additional
fields in the ip_conntrack structure.

> This requires a read lock per hash bucket while dumping that bucket, and
> some small (usually) amount of memory to keep the temporary sorted index
> of bucket entries unless the bucket is permanently resorted in which case
> it may be possible to solve with no memory allocation (but then requires
> the bucket to be write locked while resorting which is probably worse).

On the developer workshop I presented my per bucket locking patch, with
some performance comparison graphs. It's time to sync the patch and
release it...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
