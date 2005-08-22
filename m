From: "Klavs Klavsen" <kl@vsen.dk>
Subject: RE: pptp-conntrack problems
Date: Mon, 22 Aug 2005 16:18:02 +0200 (CEST)
Message-ID: <54852.195.24.8.133.1124720282.squirrel@www.enableit.dk>
References: <57F9959B46E0FA4D8BA88AEDFBE5829074D0@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <57F9959B46E0FA4D8BA88AEDFBE5829074D0@pxtbenexd01.pxt.primeexalia.com>
To: "Gary W. Smith" <gary@primeexalia.com>
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


On Mon, August 22, 2005 16:10, Gary W. Smith said:
> That command is in the readme file.  But I think there was some noise
> earlier this week stating that under 2.6.12+ you need to put
> nf_conntrack or something in place.  I wasn't paying much attention as
> I'm not there yet.
>
it must be "or something" cause nf_conntrack applied cleanly - but
pptp-conntrack still didn't apply :(

hmm. Perhaps I'll try the 2.6.13_rc6 just to see if I have better luck
with that (and hope it's stable - 2.6 has had a good run lately :)

Thank you for your insight Gary.
--=20
Regards,
Klavs Klavsen, GSEC - kl@vsen.dk - http://www.vsen.dk
PGP: 7E063C62/2873 188C 968E 600D D8F8  B8DA 3D3A 0B79 7E06 3C62

"Those who do not understand Unix are condemned to reinvent it, poorly."
  --Henry Spencer
