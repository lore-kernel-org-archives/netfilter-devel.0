From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: [POM PATCHES] IPv6 ports of time and quota matches
Date: Mon, 5 Jan 2004 13:12:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040105121244.GB16171@sch.bme.hu>
References: <000501c3c96c$c1f02e60$0e25fe0a@southpark.ae.poznan.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej =?us-ascii?Q?So=3Ftysiak?= <maciej.soltysiak@ae.poznan.pl>
Content-Disposition: inline
In-Reply-To: <000501c3c96c$c1f02e60$0e25fe0a@southpark.ae.poznan.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Maciej So=C5=82tysiak .....................................................=
....................... (2003. december 23.)

Hi,

> I noticed I have two patchsets left behind, never included in patch-o-mat=
ic
> These are IPv6 ports of the time and quota matches.
Please, be careful w/ the 'plain ports'.
Rusty has changed the internal structure of the IPv4 parts (acording the skb
linearization) - and these changes are missing from the IPv6 part. In IPv6
every packets are linearized - in IPv4 you have to linearize the required
parts avery time and in some higher-level protocols tha helper functions ha=
ve
benn changed.
(We have no size parameter in the IPv6 header (like in IPv4) so we cannot s=
eek
in the virtual skb. We have to parse the full header every time. I think th=
at
a plain linearize_all is much more cheaper.)

Regards,

	kisza=20

--=20
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /----------------------------------------------->
