From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] remove overzealous checks in REJECT target]
Date: Fri, 17 Dec 2004 06:43:39 +0100
Message-ID: <41C2720B.7@trash.net>
References: <20041216133959.GH10165@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041216133959.GH10165@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>Hi Patrick!
>
>I agree with Yasuyuki's proposed changes, do you already have this patch
>in your pending queue?
>
>I'm just asking because there was no follow-up on the list...
>
I missed it, but the patch is wrong. We must return at least 8 byte of
protocol header, so the check can't be removed. The skb_header_pointer
part looks fine, I'm going to apply it after getting some sleep.

RFC1122: §3.2.2:
Every ICMP error message includes the Internet header and at
least the first 8 data octets of the datagram that triggered
the error; more than 8 octets MAY be sent; this header and data
MUST be unchanged from the received datagram.

Regards
Patrick
