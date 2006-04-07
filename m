From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 0/3]  [RFC] fixed duration connection
Date: Fri, 07 Apr 2006 23:53:47 +0200
Message-ID: <4436DF6B.4060208@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: eric@inl.fr,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4433CCBF.6060103@trash.net>
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
> Eric Leblond wrote:
>>For this reason, we've worked on a simple kernel level implementation.
>>This is done via a second "struct timer" that is added in connection
>>structure. Activation of the timer, is for now done via userspace by
>>using libnetfilter_conntrack or by using new option -T of the conntrack
>>tool.
> 
> 
> If I understand you correctly, a fixed timeout is just a timeout that
> isn't refreshed, right? Why can't we just use the regular timers etc.
> and add a flag that it should not be touched by ip_ct_refresh? This
> would also eliminate the need for any ctnetlink changes since the
> timeout value can already be specified.

A set of patch following this recommandation is to follow.

Big thanks to Patrick !
- --
Eric Leblond

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFENt9rnxA7CdMWjzIRAjj4AKCCLFCSsT1QRpJ1Cen4PlI0qKseeACfYChO
jlewNiF3gV8IifVWoMfxshI=
=uBaq
-----END PGP SIGNATURE-----
