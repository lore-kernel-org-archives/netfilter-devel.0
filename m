From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Bugzilla webserver misconfigured?
Date: Fri, 19 Jan 2007 02:43:27 +0000
Message-ID: <45B0304F.2010401@outerspace.dyndns.org>
References: <45AF5318.8040204@outerspace.dyndns.org>
	<20070118115658.GB5236@galois.math.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20070118115658.GB5236@galois.math.uni-paderborn.de>
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
Hash: RIPEMD160

Quoting Maximilian Wilhelm on 01/18/2007 11:56 AM UTC:
| Am Donnerstag, den 18. Januar hub Jonas Berlin folgendes in die Tasten:
|
| Hi!
|
| [...]
|> ~  http://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=533
|
| When I entry this link into my browser I am redirected to
|
| https://bugzilla.netfilter.org/bugzilla/index.cgibugzilla/show_bug.cgi?id=533
|
| and get a 404.
|
| Maybe one would look at the redirect rules?

Well I'll at least take blame for the http url.. I thought https was unnecessary and only a result of me being logged in.. so I manually removed the "s" but didn't test it :(

But since the server seems to serve HTTP and indeed even does try to redirect, it seems it's supposed to be there and therefore could certainly be fixed too.. :)

- --
- - xkr47

- --
~ "if I'd make up my own definitions, unrational would be the end
~  result after someone unrationalized something i.e. actively worked
~  to cut down on rationality, whereas irrational would be more a
~  result of laziness or lack of skill"
~                - me, 23.11.2006
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFsDBOxyF48ZTvn+4RA4AFAKC7hwcGphYrjKZxB7AZlBonHYjZewCgx4pb
pw1B08HPmG8c0ol9BZ4Qb2g=
=/UHV
-----END PGP SIGNATURE-----
