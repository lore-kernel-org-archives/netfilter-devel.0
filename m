From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] ipt_physdev
Date: Tue, 11 Feb 2003 22:56:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302112256.00507.bdschuym@pandora.be>
References: <200302110051.18402.bdschuym@pandora.be> <20030211201356.GA13814@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030211201356.GA13814@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> That's perfectly fine with me. patch applied.

Thanks.

> Maybe you could add a patch for iptables.8, adding
> documentation and stating that there is no physdev support for 2.4.x ?

Sure. Just a quick question: wouldn't it be nice if the extensions were=20
discussed alphabetically in the man page? If so, I'll alphabetize them in=
 my=20
patch, else I'll just add the entry on the end of the match section.

--=20
cheers,
Bart
