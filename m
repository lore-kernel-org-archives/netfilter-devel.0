From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 04 Apr 2005 02:36:24 +0300
Message-ID: <42507DF8.9030102@outerspace.dyndns.org>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <425032D5.2010302@trash.net>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Patrick McHardy wrote:

|> Matches TCP packets that has no payload, i.e. contains only ACKs.
|
| I can see that it would be useful, given all the half-working ACK
| matching rules for shaping floating around, but we already a tcp
| match, so it should be done in there, and, if possible, kept a little

I was thinking of this, but my mind tricked me into believing that it was a
too bold thing to do..

Speaking of tcp match.. would you happen to know when the "h" union of
sk_buff is instantiated?
~   a) first time someone does -p something
~   b) somewhere before the filter table
~   c) in a seemingly unpredictable fashion
~   d) ?

I kindof recall sometimes using it and oopsing the kernel because it was not
yet initialized.. The patch I posted currently starts from nh and calculates
the tcp header start itself.. :)

| bit more generic. Perhaps a data-len match option.

I was thinking of this too but couldn't think of much use for more specific
length-matching, so I thought I'd save a few cycles.. but ok if you think
it's the way to go, I go. :)

Any parameter name suggestions? "[!] --has-payload" ?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCUH32xyF48ZTvn+4RAk4DAJ9cnX1IXU6Qn0HuWoBoZvZPakpBAACeK/lY
PsmEkZ6Bk0G9cpixt0FaJic=
=j2oo
-----END PGP SIGNATURE-----
