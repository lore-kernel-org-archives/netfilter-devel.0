From: =?iso-8859-2?q?Micha=B3_Margula?= <alchemyx@uznam.net.pl>
Subject: Re: Floods
Date: Mon, 15 Mar 2004 01:52:53 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403150152.54163.alchemyx@uznam.net.pl>
References: <200403141930.29602.alchemyx@uznam.net.pl> <20040315003440.GO26800@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040315003440.GO26800@samad.com.au>
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

Dnia pon 15. marca 2004 01:34, Alexander Samad napisa=B3:
> > What do you recommend? Unfortunately connlimit does not work with UDP
> > packets (no wonder - UDP is conection less). What should I do? I even
> > thought about switch to FreeBSD (sic! :<).
>
> What about using the rate-limit module ?

How? One rule per one IP? Wouldn't it kill performance? I was thinking abou=
t=20
dstlimit but applying patch-o-matic-ng does not create files for iptables.

=2D-=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
