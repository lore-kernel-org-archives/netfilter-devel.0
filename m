From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 0/3]  [conntrack] fixed duration connection
Date: Sat, 08 Apr 2006 00:01:58 +0200
Message-ID: <4436E156.5010306@inl.fr>
References: <1144139619.5186.24.camel@localhost.localdomain>
	<4433CCBF.6060103@trash.net> <4436DF6B.4060208@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, nufw-devel@nongnu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4436DF6B.4060208@inl.fr>
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

Hi,

This patch against conntrack tool adds support for fixed connection. for
example  :
 conntrack  -U -d 153.113.34.136 -s 192.168.11.32 -p tcp \\
	--orig-port-src 59119 --orig-port-dst 22 -t 10 \\
	-u ASSURED,SEEN_REPLY,FIXED_TIMEOUT
will fix timeout of connection to 10 seconds after command.

BR,
- --
Regit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFENuFWnxA7CdMWjzIRAqu2AJ4oOokoHVGh5KWxBv/nahkc4OtIDwCfRsqV
bPL3bs87V4eM/ymbSlnP/vc=
=IjGO
-----END PGP SIGNATURE-----
