From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] remove overzealous checks in REJECT target]
Date: Fri, 17 Dec 2004 17:59:21 +0100
Message-ID: <41C31069.6060906@trash.net>
References: <20041216133959.GH10165@sunbeam.de.gnumonks.org>
	<41C2720B.7@trash.net>
	<20041217075442.GB11436@sunbeam.de.gnumonks.org>
	<41C2B94E.4010200@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
In-Reply-To: <41C2B94E.4010200@gmx.net>
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

Carl-Daniel Hailfinger wrote:

>Well, the kernel for sure doesn't care if netfilter isn't loaded. My
>patch (and by consequence, Yasuyuki's patch) only tried to behave the
>same as a kernel without netfilter enabled.
>
>Hint: Try nmap "protocol scan" on a host without netfilter loaded. It
>will happiliy reject packets which are too short. Then enable REJECT
>for all IP protocols you don't want to support. And you'll see that
>the too short packets will suddenly stay unanswered.
>
You're right. I was misguided by this comment in icmp.c:

 *      RFC 1122: 3.2.2 MUST send at least the IP header and 8 bytes of 
header.

but icmp.c doesn't enforce this like ipt_REJECT. If no header is present, it
seems we are not required to return it :)

>
>So we either break the standard or we don't, but breaking it only if
>netfilter is not loaded doesn't sound like a sensible default to me.
>
Agreed, I'm going to apply the entire patch.

Regards
Patrick
