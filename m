From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] fixes for ipv6header/eui64 and introduce
	skb_header_pointer
Date: Thu, 04 Nov 2004 03:21:41 +0100
Message-ID: <41899235.1030309@trash.net>
References: <200411010840.iA18eeia001852@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200411010840.iA18eeia001852@toshiba.co.jp>
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

Yasuyuki Kozakai wrote:

>Hi, all
>
>These patches fix bugs in ipv6header and eui64 match.
>And also introduce skb_header_pointer() to ipv6header match.
>
All applied, thanks Yasuyuki. Could you also provide patches
with the fixes needed for 2.4 ?

Regards
Patrick
