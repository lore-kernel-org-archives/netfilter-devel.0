From: =?iso-8859-2?q?Micha=B3_Margula?= <alchemyx@uznam.net.pl>
Subject: Re: Floods
Date: Mon, 15 Mar 2004 20:31:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403152031.27399.alchemyx@uznam.net.pl>
References: <200403141930.29602.alchemyx@uznam.net.pl> <877jxmuopm.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <877jxmuopm.fsf@aka.i.naked.iki.fi>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dnia pon 15. marca 2004 16:14, Nuutti Kotivuori napisa=B3:
> Micha wrote:
> > What do you recommend? Unfortunately connlimit does not work with
> > UDP packets (no wonder - UDP is conection less). What should I do? I
> > even thought about switch to FreeBSD (sic! :<).
>
> See if the 'dstlimit' would help in your case. It is in patch-o-matic.
>
> -- Naked

But it does not support '--mode srcip' and I failed trying to adpot patch f=
rom=20
before few months that tried to add that option.

=2D-=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
