From: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Subject: Re: [PATCH] remove overzealous checks in REJECT target
Date: Thu, 16 Dec 2004 00:31:47 +0100
Message-ID: <41C0C963.4040309@gmx.net>
References: <41AD67A3.6090608@gmx.net>
	<200412020617.iB26H6ut018405@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200412020617.iB26H6ut018405@toshiba.co.jp>
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

Yasuyuki Kozakai schrieb:
> I think so. This check isn't needed.
> 
> And I found strange codes after this check: directly access to the data
> in skb.h and overwriting ICMP header with same data.
> 
> I think we should use skb_header_pointer() to get UDP/ICMP header.
> 
> Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

When will this patch get into mainline?

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
