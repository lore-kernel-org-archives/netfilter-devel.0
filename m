From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: Fw: [PATCH 2.4.22] looseUDP support
Date: Wed, 14 Apr 2004 08:42:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF56792D4@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>,
	"John Ho" <john_ho@sh.askey.com.tw>
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
> On Wed, 14 Apr 2004, John Ho wrote:
>=20
>>  May be helpful. I've met this problem and cannot find a solution for
>> netfilter framework to support looseUDP feature.
>=20
> What is looseUDP?

Loose UDP is a dynamicly sending UDP packets to machines behind the
firewall instead of openning ports accordingly. Its probably a bad idea
to use the 2.2 kernel these days now that there are a few more UDP based
windows attacks.

What would you like to do with Loose UDP that you can't do with the
current iptables/netfilter? Remember, netfilter actually have session
tracking now, which pretty much eliminated the need for that creative
solution to an at-the-time network problem.
