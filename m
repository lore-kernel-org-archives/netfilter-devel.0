From: Tom Eastep <teastep@shorewall.net>
Subject: Re: Policy match with a bridge
Date: Wed, 13 Oct 2004 17:23:11 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416DC6EF.9050001@shorewall.net>
References: <411EAF08.3000401@shorewall.net> <411F7B87.7060303@shorewall.net>
	<41200E80.2000005@trash.net>
	<200408192010.28417.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bridge@osdl.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200408192010.28417.bdschuym@pandora.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Bart De Schuymer wrote:
> On Monday 16 August 2004 03:31, Patrick McHardy wrote:
>
>>The problem is ipv4_sabotage_out in the briding code. It prevents the
>>packet from hitting the LOCAL_OUT hook while it is still unencrypted.
>>When it hits the bridging code and its LOCAL_OUT hook it's too late.
>>Not sure how to handle it yet.
>
>
> I'll have a look at that after I'm finished with the IPv6 bridge
firewalling
> stuff.
>

Any progress on this?

Thanks,
- -Tom
- --
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBbcbvO/MAbZfjDLIRAmBsAJsFlFdf6+c5tzT8Z5OGG/nnxoL//wCghS8L
hX2rkQdtF2v7YIwRyfRDLIY=
=6sB9
-----END PGP SIGNATURE-----
