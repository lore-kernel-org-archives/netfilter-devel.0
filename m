From: =?iso-8859-2?q?Micha=B3=20Margula?= <alchemyx@uznam.net.pl>
Subject: Re: ip_conntrack
Date: Thu, 6 Mar 2003 09:21:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303060921.23809.alchemyx@uznam.net.pl>
References: <200303040107.28400.alchemyx@uznam.net.pl> <200303052128.12562.alchemyx@uznam.net.pl> <20030305210652.GI4880@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20030305210652.GI4880@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dnia =B6ro 5. marzec 2003 22:06, Harald Welte napisa=B3:
>
> is there anything particular about the /proc/net/ip_conntrack entries?
> like lots of UNREPLIED entries, ...?
>

Main problem with ip_conntrack entries is that when I scan it, let say wi=
th=20
"wc -l" my network traffic stops for one or two minutes.

> > Please tell me how. Thank you!
>
> modinfo ip_conntrack
>
> please refer to the mailinglists(s), I cannot support all tens of
> thousands of netfilter users on my own.

Sorry. Didn't notice it was comming directly to you.
Another solution given by few people on other lists is to play with timeo=
uts=20
on ip_conntrack?

--=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/ +)
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
