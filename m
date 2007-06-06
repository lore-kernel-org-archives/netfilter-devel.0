From: Amin Azez <azez@ufomechanic.net>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Wed, 6 Jun 2007 16:58:43 +0100
Message-ID: <200706061718.l56HIjv08406@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Patrick McHardy <kaber@trash.net>, Jan Engelhardt <jengelh@linux01.gwdg.de>
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

So is it necessary to resubmit the kernel patch with the un-necessary match=
es turned into explanatory comments?

Sam

-----Original Message-----
From: "Patrick McHardy" <kaber@trash.net>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Netfilter Developer Mailing List" <netfilter-devel@lists.netfilter.org=
>; "Amin Azez" <azez@ufomechanic.net>
Sent: 06/06/07 12:31
Subject: Re: xt_gateway 20070605 (kernel)

Jan Engelhardt wrote:
> On Jun 5 2007 17:15, Patrick McHardy wrote:
>=20
>>Most of the checks here are unnecessary anyway (we always
>>have a skb with skb->dst !=3D NULL, neigh->tbl is always !=3D NULL
>>and the neighbour table family is always AF_INET since the
>>match is only registered for AF_INET.
>=20
>=20
> Thanks for letting us now. Now, prime question: Is skb always !=3D NULL?
> (Otherwise it would not really make sense calling the match if
> there was nothing to match.)


Yes.
