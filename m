From: Sven Anders <anders@anduras.de>
Subject: Re: Reset conntrack...
Date: Wed, 08 Dec 2004 12:20:25 +0100
Message-ID: <41B6E379.5070909@anduras.de>
References: <41AF92B1.30802@anduras.de>
	<20041203060819.GG4605@oknodo.bof.de>	<41B049C5.403@anduras.de>
	<41B0D5AB.6050403@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080208090203080306010600"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <41B0D5AB.6050403@gmx.net>
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

This is a multi-part message in MIME format.
--------------080208090203080306010600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Carl-Daniel Hailfinger wrote:
| Sven Anders schrieb:
|
|>Patrick Schaaf wrote:
|>|>Is it possible to reset the conntrack list or set any entry to the state
|>|>NEW to force a recheck against new filter rules?
|>|>~  If I set the (new) filtering rules with the target DROP, I want old
|>|>~  (existing) connections to be dropped immediatly.
|>|
|>|
|>| Consider using REJECT. This has two advantages: it gives the end
|>| systems you are now blocking a chance at state cleanup (instead of
|>| needlessly wasting memory and CPU resources on a connection that you
|>| now elect to forbit). But, the greater advantage: the packets that
|>| the end systems exchange in response to the connection teardown,
|>| are JUST what you need to get rid of their conntracks.
|>
|>This is not exactly what I'm meant...
|>
|>Consider the following scenario:
|>
|>~ 1. Set firewall rules
|>~     with:
|>~      a) ACCEPT on all --state RELATED,ESTABLISHED
|>~      b) with ACCEPT on ports 22 and 80
|>
|>~ 2. Remote client creates connection through the firewall
|>~     on the port 80 (CONNTRACK state is: NEW)
|>~     It will be allowed due to the ACCEPT policy...
|>
|>~ 3. Server answers and connection CONNTRACK state will be changed
|>~    to ESTABLISHED
|>
|>~ 4. Set new firewall rules:
|>~      Changed b) to only allow port 22
|>
|>~ 5. The connection to port 80 will continue to exists, because
|>~    it CONNTRACK state did not change and we have rule a)...
|>
|>Possible solutions:
|>
|>~ 1) Recheck all CONNTRACK entries against the new firewall rules.
|>
|>~ 2) Set all CONNTRACK entries with states RELATED or ESTABLISHED to
|>~     NEW, to force the recheck.
|
|
| Why so complicated? Insert a rule which rejects connections to port 80
| before rule a). That way any packet coming to you on port 80 will cause
| a reset, tearing down the connection and the problem is solved. The only
| disadvantage is that your machine may continue sending data until it
| requires an ack of the remote side to continue. That ack will then cause
| teardown, too. If that is not good enough, consider adding a reject
| rule for source port 80 in your OUTPUT table.
| This will cause any connection which is now forbidden to be teared down
| once either side wants to send any data.

The rules will be set by an (normal) user. So I cannot assume the user to
understand why he should insert this rule too...
Automatically generating this rule is complicated too, because this
rule could conflict with some other rule...

|>Is there any way to accomplish this?
|
| Yes. (Well, it forces you to add an explicit REJECT rule for every
| ACCEPT rule you remove, but that is less complicated than patching the
| kernel.)

Regards
~ Sven

- --
~ Sven Anders <anders@anduras.de>

~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBtuN45lKZ7Feg4EcRAoZ/AJ9W37rM1Sf9F/8sScUbsokItmItRwCeMUr2
++4zWG66gUGeIA0Rn25X/WI=
=F92r
-----END PGP SIGNATURE-----

--------------080208090203080306010600--
