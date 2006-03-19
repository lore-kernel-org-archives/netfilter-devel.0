From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Interesting problem with conntrack and ftp
Date: Sun, 19 Mar 2006 01:37:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0603190134110.16079@bizon.gios.gov.pl>
References: <20060316235511.GA18440@hufpuf.lan1.hme1.samad.com.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1683039739-1142728659=:16079"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20060316235511.GA18440@hufpuf.lan1.hme1.samad.com.au>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1683039739-1142728659=:16079
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 17 Mar 2006, Alexander Samad wrote:

> Hi
>
> I was resently setting up my new firewall usimng openwrt on a linksys.
>
> I got around to setting up my adsl connection and added into my iptables
> these commands
>
>
>
> $IPT -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
> $IPT -t filter -A FORWARD -o $WANADSL -p tcp --tcp-flags SYN,RST SYN -j T=
CPMSS --clamp-mss-to-pmtu
> $IPT -t nat -A POSTROUTING -o $WANADSL -j MASQUERADE
>
> which is what I have normally done.
>
> http traffic worked well, but ftp of large files, timed out, sign of a
> mtu problem. It worked when I ftp'ed from the firewall, but not when I
> did it from behind the firewall.
>
> When I did some tcpdumps, I noticed that the second connection created
> by the client wasn't being clamp'ed.
>
> The way I figure it was that the second connection was related to the
> first one, and thus being consumed by the first line in iptables (above)
>
> Once I changed the order of line 1 and 2 every thing worked fine.
>
> Now openwrt uses 2.4.30, and my previous firewall used 2.6 and I believe
> it was setup as shown above and it worked fine.
>
> The other difference is that conntrack_ftp is compiled into the kernel.
>
> Is this a know feature/bug ? why has it worked in 2.6 and not in 2.4 or
> is the problem in compiled in and as a module

The solution is simple: TCPMSS should be used only in mangle table.=20
Anyway, if you didn't change the configuration I have no idea why it=20
worked in 2.6 and does not work in 2.4.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1683039739-1142728659=:16079--
