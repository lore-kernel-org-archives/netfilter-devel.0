From: Patrick McHardy <kaber@trash.net>
Subject: Re: Pb using DROP in a PREROUTING hook with ip6tables
Date: Mon, 18 Apr 2005 00:14:12 +0200
Message-ID: <4262DFB4.6030308@trash.net>
References: <425FE3C6.6070807@enseirb.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hadrien HAMEL <hamel@enseirb.fr>
In-Reply-To: <425FE3C6.6070807@enseirb.fr>
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

Hadrien HAMEL wrote:
> Kernel messages show that the mldv2 packets are recognized (and so the
> match function returns 1) but the packet aren't dropped. I've tried the
> "mangle" table and the "raw" table, but both were ineffective. To be
> sure that my module wasn't misbehaving, I tried to drop all the packets
> in PREROUTING, with no effects. In comparison, the same command with
> iptables (thus in IPv4) has blocked all the incoming packets (which is a
> normal behaviour!).
> 
> Does anybody know if there is such a bug in ip6tables? Or is this a
> misuse of it?

Works fine here:
# ip6tables -t raw -A PREROUTING -j DROP

ping6 ::1 gets no responses

# ip6tables -t raw -F

ping6 ::1 works again

Regards
Patrick
