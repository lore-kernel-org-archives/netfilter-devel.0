From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Sun, 22 Aug 2004 09:49:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41285006.2070904@sch.bme.hu>
References: <1092407190.2402.120.camel@nienna.balabit> <4127EB7C.60103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: KOVACS Krisztian <hidden@balabit.hu>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4127EB7C.60103@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Patrick McHardy wrote:
> Are there any differences between the nfnetlink-ctnetlink patch and the
> ctnetlink patch in the netfilter-ha repository ? Porting ctnetlink to
> 2.6 would be a start. Maybe someone wants to do it, otherwise I'll do
> it on a rainy day ..

   No, there is no difference apart from a small change I've already=20
mentioned on netfilter-devel wrt the NATINFO notification. For details, s=
ee

http://lists.netfilter.org/pipermail/netfilter-devel/2004-August/016225.h=
tml

   AFAIK the ctnetlink patch has already been ported to 2.6, and a patch=20
was sent to the mailing list. Unfortunately I was unable to find that=20
mail in the mailing list archives...

--=20
   KOV=C1CS, Kriszti=E1n
