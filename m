From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Wed, 3 Jul 2002 06:15:02 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020703041502.GH20570@aaricia.hemmet.chalmers.se>
References: <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com> <20020702183242.E7684@oknodo.bof.de> <20020702183547.F7684@oknodo.bof.de> <15649.59247.55523.824241@isis.cs3-inc.com> <20020702203117.G7684@oknodo.bof.de> <20020702235206.H7684@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020702235206.H7684@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-02 23:52:06+0200, Patrick Schaaf <bof@bof.de> ->
> Hi all,
> 
> I have put a tarball at http://bei.bof.de/cttest-0.1.tar.gz
> Unpack, look at README, and reproduce the gnuplot pictures I have
> mentioned earlier today (at http://bei.bof.de/ex1/)
> 
> I would love to see results from other kinds of workloads.
> 
> thanks in advance
>   Patrick

I've tested it on our router data. The router holds one mayor DALnet server
(~7000K users) and one minor EFnet-server (~700 users) behind. Also about
1000 student computers. The DALnet-server was attack today and yesterday
with 70K pps icmp reply. However I filtered that (in mangle PREROUTING) fast
and I don't know how much impact is show in the conntrack. I also have
limiters on state NEW to prevent attacks to fill the conntrack.

Graphs at: http://aaricia.hemmet.chalmers.se/~gozem/cttest/

Stats for the actuall running conntrack is:
$MODPROBE ip_conntrack hashsize=131072 
echo 262144 > /proc/sys/net/ipv4/ip_conntrack_max
(Yes meaning average bucket-length to be 2 not 8).

Conntrack was using about 50K slabs according to /proc/slabinfo

However looking at the stats, I will change hashsize to a primenumber 
fast :-)

I collected this data 5am during absolut low time. I'll try again later
at primetime :-)

One comment: In your script ctplot you have an absolute path to gnuplot
which I guess not everyone has the same as you :-)


-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
