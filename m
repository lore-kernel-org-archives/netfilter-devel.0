From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [RFC] Match wants to change skbuff (nfcache)
Date: Wed, 15 Dec 2004 09:01:24 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412131258330.19191@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Currently a match function cannot modify the skbuff. However, sometimes
it'd be useful to be able to modify at least the nfcache field.

An example: I'm working on porting the unclean match to 2.6. But how nice
would it be if the unclean match could notify the error function of the
TCP window tracking code that it had already verified the packet and found
it clean. nfcache comes as a possibility to pass the required info, but
match function cannot touch it.

It'd be easy and simple to drop 'const' from the definiton of the match
function, but a match should not poke with skbuff so 'const struct
sk_buff *skb' is just the right thing.

What I suggest is to add '__u32 *nfcache' to the argument list of the
match functions.

Are there better alternatives?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
