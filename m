From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: Dell PE2650 with integrated Broadcom NIC and NIC hardware TCP
	checksums messes up PPTP
Date: Wed, 27 Sep 2006 15:07:14 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206FBDF@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: prossow@ScholarshipAmerica.org, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>,
	Mike McRae <Mike_McRae@schneidermans.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: =?iso-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
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

> Are you running latest firmware in the NIC ?

Don't know, don't care.  We just turned off the hardware checksums.  =
We're already poured enough time into this problem.  These servers are =
not very busy anyway so using a little bit of CPU to calculate checksums =
should not be a big deal.

- Greg
