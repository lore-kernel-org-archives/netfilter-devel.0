From: Andreas Jellinghaus <aj@dungeon.inka.de>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 11:30:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <pan.2004.01.28.10.30.03.44921@dungeon.inka.de>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

ah_output to ah_output_finish and a new ah_output
with:
> +	return NF_HOOK(PF_INET, NF_IP_POST_ROUTING, skb, skb->dev, ah_dummydev,
> +		       ah_output_finish);

please add the same to ipip, ipgre and friends, to keep them
in sync? what about ipv6?

Andreas
p.s. I hope the idea with the new hook POSTENCAP died?
