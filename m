From: =?iso-8859-2?q?Micha=B3=20Margula?= <alchemyx@uznam.net.pl>
Subject: Re: ip_conntrack
Date: Tue, 4 Mar 2003 09:27:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303040927.33460.alchemyx@uznam.net.pl>
References: <200303040107.28400.alchemyx@uznam.net.pl> <20030304073324.GI25876@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030304073324.GI25876@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dnia wto 4. marzec 2003 08:33, Patrick Schaaf napisa=B3:
>
> Sigh.  Your command is not supposed to work.  Use:
>
> echo 256000 > /proc/sys/net/ipv4/ip_conntrack_max
>
> regards
>   Patrick

Works. So my solution was bad :). Thank you!

--=20
Micha=B3 Margula, alchemyx@uznam.net.pl, http://alchemyx.uznam.net.pl/ +)
"W =BFyciu pi=EAkne s=B1 tylko chwile" [Ryszard Riedel]
