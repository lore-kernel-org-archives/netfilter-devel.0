From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 9 Dec 2004 14:21:58 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412091414450.11649@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<41B84441.7080402@kde.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grzegorz Piotr Jaskiewicz <gj@kde.org.uk>
In-Reply-To: <41B84441.7080402@kde.org.uk>
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

On Thu, 9 Dec 2004, Grzegorz Piotr Jaskiewicz wrote:

> That is a good idea, but asside that I think that we need some kind of
> 'grabage collector' that is going to remove the oldests connections from
> the hash to make space for those new.

We have already got such garbage collection, which is simple, clean and
natural: timeout.

> This sounds a bit more
> complicated, I know, maybe someone has a better idea about it.
> But to be honest letting someone to manage computer remotely is the one
> thing, and letting system to solve the problem on its own is another.
> Now that you can get in, tell me what you can do ?
> You can resize hash table size for instance, but so can netfilter on its
> own in case hash is filled to the brim.

I don't really believe in resizing in the case of conntrack. The admin
knows how much memory is available in the machine and should better load
in the conntrack module with the most appropriate hash size value.
Resizing *is* expensive and even more so when the machine is just under an
attack.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
