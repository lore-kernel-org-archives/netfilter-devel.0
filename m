From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: RPC patch creates kernel panic
Date: Thu, 1 Apr 2004 14:34:56 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5679291@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Ian Latter" <Ian.Latter@mq.edu.au>,
	"John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ian Latter wrote:
> Hello John,
>=20
>=20
>   Thank you for this report.
>=20
>   The RPC conntrack helper was written to support ONC RPC -
> typically used on Unix hosts - where as Windows uses DCE RPC.
> When I last looked at that module, I tried to find technical
> information on the differences of the two, and was unable to
> find any - but had the impression from what I could find that the
> two weren't compatible.
>=20
>   Whether or not the module recieves valid/invalid traffic, it
> shouldn't crash - and I want to fix that.=20
>=20
>   However, if you have access to documentation on DCE RPC
> protocol/standards then please forward that/them through, as any
> such documentation would be useful for broadening support.

How's this?
http://www.opengroup.org/onlinepubs/9629399/toc.htm
