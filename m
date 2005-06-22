From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Valid netmasks for nethash type IP sets?
Date: Wed, 22 Jun 2005 08:40:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506220832090.5627@blackhole.kfki.hu>
References: <42B822D0.9040401@ingate.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <42B822D0.9040401@ingate.com>
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

On Tue, 21 Jun 2005, Marcus Sundberg wrote:

> is there any particular implementation detail behind the reason why
> the nethash set rejects the special case of /32 and /0 ? I would find
> it quite convenient if the nethash set was able to store "networks"
> consisting of a single address as well as the "everything" network.

/0 (or 0) cannot be stored in any ipset type because zero value means
"element not set". /32 cannot be stored in nethash due to the packing
algorithm: with the chosen method it was possible to store the network
address and netmask value together just in 32 bits. And for single
addresses you can use iphash anytime.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
