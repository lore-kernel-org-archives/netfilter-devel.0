From: laurent.ml@linuxfr.org
Subject: Re: DNAT dosen't work
Date: Sat, 11 Oct 2003 16:51:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <wazza.87d6d3u8tb.fsf@message.id>
References: <A59F9B5C2A83424F9A8679E1BAB3E56610DCAA@exchange.zoodomain.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Slav Rilov" <Slav.Rilov@Zoo.org>
In-Reply-To: <A59F9B5C2A83424F9A8679E1BAB3E56610DCAA@exchange.zoodomain.org> (Slav
 Rilov's message of "Fri, 10 Oct 2003 16:06:17 -0700")
Resent-Message-Id: <20031011145310.9C8F5A6F1@fozzy.syrius.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

"Slav Rilov" <Slav.Rilov@Zoo.org> writes:

> I am building dual host: eth1 - external, eth0(10.10.1.1 255.255.0.0) - internal interface 
> iptables -P INPUT DROP
> iptables -P OUTPUT DROP
> iptables -P FORWARD DROP
>
> iptables -t nat -A PREROUTING -i eth1 -j DNAT --to-destination 10.10.1.1
> iptables -A INPUT -i eth0 -j ACCEPT
> iptables -A INPUT -i eth1 -j ACCEPT

You should consider adding a FORWARD rule to let traffic go from eth1
to 10.10.1.1(eth0)
The correct mailing list for that kind of question is netfilter-user !

-- 
Laurent
