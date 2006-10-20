From: Patrick McHardy <kaber@trash.net>
Subject: Re: queue_maxlen
Date: Fri, 20 Oct 2006 12:03:58 +0200
Message-ID: <45389F0E.6000000@trash.net>
References: <2BDDB86A-ABD4-4C53-AE17-498AB0F52B28@cadvium.net>
	<1161125685.4002.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: robert <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1161125685.4002.33.camel@localhost.localdomain>
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

Eric Leblond wrote:
> Hi,
>=20
> Le mardi 17 octobre 2006 =E0 15:43 -0700, robert a =E9crit :
>=20
>>Does NFQUEUE use the value in /proc/sys/net/ip_queue_maxlen?  If not, =20
>>is it possible to modify the maximum queue length for NFQUEUE?
>=20
>=20
> Not with vanilla tree.
>=20
> I've post a patch to enable it some times ago but It has not been
> incorporated into main tree :
>=20
> http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3628
> http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3629
>=20
> With that patch it is possible to do so on a per-queue basis by using
> the new function nfq_set_queue_maxlen.

Please resend, I probably missed it.
