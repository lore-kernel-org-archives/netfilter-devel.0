From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: CONNMARK again..
Date: Mon, 22 Mar 2004 18:42:59 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5679238@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Mon, 22 Mar 2004, Daniel Chemko wrote:
>=20
>> Ok, I wrote a few weeks back about getting policy routing working. I
>> did!=20
>>=20
>> The problem is that I've updated to the latest 2.4 POM and -j
>> CONNMARK --save-mark doesn't seemt o be working anymore.
>=20
> Have you updated your iptables userspace? CONNMARK was cleaned up some
> time ago and new kernels is not compatible with old binaries..
>=20
> Regards
> Henrik

This is a freshly compiled 1.2.9 against the current kernel. Unless the
API for CONNMARK has changed in the backend since 1.2.9 I don't see how.
The userspace did compile against the updated POM kernel, so I'm not
sure else where it fails. New iptables binaries dfrom CVS reports
"Invalid argument" or the such when doing NAT work, so I am stuck to
1.2.9...
