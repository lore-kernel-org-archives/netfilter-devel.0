From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK 6/9]: Drop conntrack reference when packet
 leaves IPv6
Date: Tue, 14 Jun 2005 03:21:56 +0200
Message-ID: <42AE3134.7030905@trash.net>
References: <200505230620.j4N6KAve018200@toshiba.co.jp>	<42AB0452.3010703@trash.net>
	<200506130058.j5D0wRPG007718@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200506130058.j5D0wRPG007718@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sat, 11 Jun 2005 17:33:38 +0200
> 
>>Why not simply drop the reference earlier in ip6_input_finish()
>>before the packet is delivered to raw sockets?
> 
> Because IPv6 packets with routing header are forward at ipv6_rthdr_rcv()
> called in ip6_input_finish().

Thanks, I've applied that one too. I'll update the patch once I've
moved the repository to git.

Regards
Patrick
