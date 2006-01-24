From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: [PATCH] [NETFILTER] Fix CID offset bug in PPTP NAT helper
Date: Tue, 24 Jan 2006 13:36:19 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A2031F1C@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>,
	"Holger Eitzenberger" <heitzenberger@astaro.com>
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

I've always wondered - patches for modules in POM-NG are available right
away with the next daily snapshot.  But the PPTP stuff is now in the
mainline kernel.  Would this patch end up in one of the snapshot or rc
releases on kernel.org, or are there updates to the 2.6.15.1 tree or how
does that work?  Or would the most up to date PPTP stuff still be in
POM-NG?

Thanks

- Greg Scott


-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
Patrick McHardy
Sent: Tuesday, January 24, 2006 12:00 PM
To: Holger Eitzenberger
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: [PATCH] [NETFILTER] Fix CID offset bug in PPTP NAT helper

Holger Eitzenberger wrote:
> The recent (kernel 2.6.15.1) fix for PPTP NAT helper introduced a bug=20
> - which only appears if DEBUGP is enabled though.
>=20
> The calculation of the CID offset into a PPTP request struct is not=20
> correct, so that at least not the correct CID is displayed if DEBUGP=20
> is enabled.
>=20
> This patch corrects CID offset calculation and introduces a #define=20
> for that.

That was my bad. Patch applied, thanks.
