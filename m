From: Sven Anders <anders@anduras.de>
Subject: Re: new ABI
Date: Thu, 24 Aug 2006 09:57:15 +0200
Message-ID: <44ED5BDB.6000006@anduras.de>
References: <200608142312.41851.max@nucleus.it>
	<200608160057.05431.max@nucleus.it> <44EC991F.7020909@anduras.de>
	<200608232319.22120.max@nucleus.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080601030206010807030006"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <200608232319.22120.max@nucleus.it>
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
--------------080601030206010807030006
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Massimiliano Hofer schrieb:
> On Wednesday 23 August 2006 8:06 pm, Sven Anders wrote:
> 
>>> The real question thus becomes: is it worh to restart from (almost)
>>> scratch?
>> In my personal opinion it's time for a new API.
>> During the implementation of my program, I run into many problems which
>> could only be solved clearly by a new API. It would make the implementation
>> of other user-space programs (beside iptables) much easier.
> 
> Do you mean ABI?

Oops, yes :-)

>> I would love to have unique rule ids! 8-)
> 
> Would a number be sufficient, or do you think a user supplied string would be 
> much more useful? Of course the kernel will assign default ids to id-less 
> rules.

In my current application I use the 'comment' "match" for assigning unique ID to
my rules. These rule consist of a plain hex-number.
I think it would be sufficent, if it's a plain number, but a string may be more
useful for an end-user. If it's will be still possible to attach a comment to a
rule, I recommend an integer (easier to handle by the kernel / to compare and
uses less memory).

>>    I think this could be done with little changes on the current netfilter
>> core too, but it would be better to do it in a new framework. You only have
>> to distinguish between VERIDICT and NON-VERDICT targets.
>
> The current data structures will be completely wiped away. This isn't a little 
> change and will need a lot of testing.

Yes, but I only wanted to make clear, that this is a change that could be done
in the current structure too. Nevertheless I vote for a new ABI.

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

iD8DBQFE7Vvb5lKZ7Feg4EcRAsdIAKChgn1cuOsd+5I8o3gUkHQc7IxBNQCeIvA7
3pWkDFUA68MAhhzqK8SwC/U=
=xqQQ
-----END PGP SIGNATURE-----

--------------080601030206010807030006--
