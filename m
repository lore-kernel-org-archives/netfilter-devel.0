From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] new 'tcpack' match
Date: Mon, 04 Apr 2005 03:07:07 +0300
Message-ID: <4250852B.2010802@outerspace.dyndns.org>
References: <42464598.9040707@outerspace.dyndns.org>
	<425032D5.2010302@trash.net>
	<42507DF8.9030102@outerspace.dyndns.org>
	<20050403235141.GA28850@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050403235141.GA28850@linuxace.com>
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

Phil Oester wrote:

|>Any parameter name suggestions? "[!] --has-payload" ?
|
| How bout just a '--datalen [!] X', where X can be any number, including 0?

Oops getting sleepy..

Yeah, datalen perhaps.. but should it maybe also match a range instead of
just one exact length?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCUIUkxyF48ZTvn+4RAh72AJoCTo+gkpYRYcwcA4srpkKYTaal5QCfe1S/
/YN5r6+OjwrZDQrSmHOI6gI=
=XW4e
-----END PGP SIGNATURE-----
