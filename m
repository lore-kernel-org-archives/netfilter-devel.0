From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Sat, 24 Apr 2004 13:51:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408A54CB.3040403@trash.net>
References: <20040415212034.GE7611@obs.bg> <407FE99D.6010100@trash.net> <20040424101748.GB23401@obs.bg> <408A4C2F.3050209@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ivan Mitev <imitev@obs.bg>
In-Reply-To: <408A4C2F.3050209@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Just to avoid confusion, there is a small mistake in my setkey script.
I replaced the local tunnel-address with 0.0.0.0 to see if it will be
set automatically. It works, but I haven't tested the policy match with
this configuration.

Patrick McHardy wrote:

> setkey:
> spdadd 192.168.0.23/32 0.0.0.0/0 any
>         -P out ipsec
>         esp/tunnel/0.0.0.0-192.168.0.1/require
                      ^192.168.0.23
>         ah/transport//require;
> 
> spdadd 0.0.0.0/0 192.168.0.23/32 any
>         -P in ipsec
>         esp/tunnel/192.168.0.1-0.0.0.0/require
                                  ^192.168.0.23
>         ah/transport//require;
> 
> policy match:
> iptables -A INPUT -m policy --dir in --pol ipsec --strict --proto esp
>  --mode tunnel --tunnel-src 192.168.0.1 --tunnel-dst 192.168.0.23 --next
>  --proto ah --mode transport
> 
> iptables -A OUTPUT -m policy --dir out --pol ipsec --strict --proto esp
>  --mode tunnel --tunnel-src 192.168.0.23 --tunnel-dst 192.168.0.1 --next
>  --proto ah  --mode transport
