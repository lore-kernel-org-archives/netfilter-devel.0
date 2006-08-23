From: Sven Anders <anders@anduras.de>
Subject: Re: new ABI
Date: Wed, 23 Aug 2006 20:06:23 +0200
Message-ID: <44EC991F.7020909@anduras.de>
References: <200608142312.41851.max@nucleus.it>	<200608151414.24599.simon@parknet.dk>
	<200608160057.05431.max@nucleus.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070804080809030904050000"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <200608160057.05431.max@nucleus.it>
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
--------------070804080809030904050000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Massimiliano Hofer schrieb:
> On Tuesday 15 August 2006 2:14 pm, Simon Lodal wrote:
> 
>> Everybody has a long wishlist and seem to agree that something fundamental
>> needs to be done.
>>
>> The question seems to be when backwards compatibility can be given up.
> 
> Everyone agrees that we have reached the maximum expressiveness with the 
> current system.
> Nobody says that we couldn't keep a way to convert old rules in the new 
> system.
> The real question thus becomes: is it worh to restart from (almost) scratch?

In my personal opinion it's time for a new API.
During the implementation of my program, I run into many problems which could
only be solved clearly by a new API. It would make the implementation of other
user-space programs (beside iptables) much easier.

> Either way we'll need some form of rule and match id.
> I don't know what level of transactionality is desired. Currently 
> iptables-restore is atomic and so are single changes with iptables. How much 
> is needed with the new system? At least rule level atomicity is certainly 
> desired, so we'll need to create duplicate data (just the core structure with 
> pointers to the real descriptors) during modifications.

I would love to have unique rule ids! 8-)

If you implement a new API, you could support the following too:

 - boolean logic between matches
   Example:
     rule 2 { src-ip 1.2.3.4/24 and protocol TCP and
              ( port 21 or port 23 or port 25 ) } accept }

 - multiple targets
   Example:
     rule 3 { protocol TCP and port 22 ulog { prefix "SSH Access" } accept }

   I think this could be done with little changes on the current netfilter core
   too, but it would be better to do it in a new framework. You only have to
   distinguish between VERIDICT and NON-VERDICT targets.

  - Get the counters of [single] rules (and reset them) without completely
    setting the whole firewall once again.

  - A NOT for all matches

This would also make some matches obsolete (multiport for instance).

Regards
 Sven

- --
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
                                                 /\ Support plain text e-mail
 ANDURAS service solutions AG
 Innstraße 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Thomas Träger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFE7Jkf5lKZ7Feg4EcRAiAbAKCQZe9QqcOPsDqA5QUWXaag15DGawCfbk72
rLC2Ayk9H9w66juw3HQrf2A=
=5A4W
-----END PGP SIGNATURE-----

--------------070804080809030904050000--
