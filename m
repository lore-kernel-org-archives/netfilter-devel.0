From: Amin Azez <azez@ufomechanic.net>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Fri, 15 Jun 2007 18:20:19 +0100
Message-ID: <200706151843.l5FIhLv18998@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Patrick McHardy <kaber@trash.net>, Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I agree that pointless checks are not needed at runtime.

I am not sure what other changes I should make to stop people crashing the =
kernel by using this match in places I have not forseen.

I am not certain that my anticpated crashes are actually possible.

Patrick, If I merely remove these unnecessary tests, will you be satisfied =
with the result?

Sam

-----Original Message-----
From: "Patrick McHardy" <kaber@trash.net>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Amin Azez" <azez@ufomechanic.net>; "Netfilter Developer Mailing List" =
<netfilter-devel@lists.netfilter.org>
Sent: 15/06/07 17:15
Subject: Re: xt_gateway 20070605 (kernel)

Jan Engelhardt wrote:
> On Jun 15 2007 12:30, Amin Azez wrote:
>=20
>>>and the neighbour table family is always AF_INET since the
>>>match is only registered for AF_INET.
>>> =20
>>
>>Maybe if I take out these checks, I should restrict the match to FORWARD
>>and POSTROUTING?
>=20
>=20
> Leaving them in does not cost too much.


Thats no reason to keep pointless checks around.
