From: Ivan Mitev <imitev@obs.bg>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Sat, 24 Apr 2004 16:07:57 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040424130756.GF23401@obs.bg>
References: <20040415212034.GE7611@obs.bg> <407FE99D.6010100@trash.net> <20040424101748.GB23401@obs.bg> <408A4C2F.3050209@trash.net> <408A54CB.3040403@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <408A54CB.3040403@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hello patrick,

AH+ESP actually works well ; that was my mistake - i played with some other
things and accidentaly dropped AH proto pkts :(  - sorry

thanks for your reply !

ivan


On Sat, Apr 24, 2004 at 01:51:39PM +0200, Patrick McHardy wrote:
> Just to avoid confusion, there is a small mistake in my setkey script.
> I replaced the local tunnel-address with 0.0.0.0 to see if it will be
> set automatically. It works, but I haven't tested the policy match with
> this configuration.
> 
> Patrick McHardy wrote:
> 
> >setkey:
> >spdadd 192.168.0.23/32 0.0.0.0/0 any
> >        -P out ipsec
> >        esp/tunnel/0.0.0.0-192.168.0.1/require
>                      ^192.168.0.23
> >        ah/transport//require;
> >
> >spdadd 0.0.0.0/0 192.168.0.23/32 any
> >        -P in ipsec
> >        esp/tunnel/192.168.0.1-0.0.0.0/require
>                                  ^192.168.0.23
> >        ah/transport//require;
> >
> >policy match:
> >iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp
> > --mode tunnel --tunnel-src 192.168.0.1 --tunnel-dst 192.168.0.23 --next
> > --proto ah --mode transport
> >
> >iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp
> > --mode tunnel --tunnel-src 192.168.0.23 --tunnel-dst 192.168.0.1 --next
> > --proto ah  --mode transport

-- 
