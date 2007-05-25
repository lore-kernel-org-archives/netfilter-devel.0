From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Fri, 25 May 2007 13:11:41 +0900 (JST)
Message-ID: <200705250411.l4P4Bg6U021261@toshiba.co.jp>
References: <465528CB.4020108@snapgear.com>
	<200705250044.l4P0i3f8007580@toshiba.co.jp>
	<4656342A.5040202@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: philipc@snapgear.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4656342A.5040202@snapgear.com>
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

From: Philip Craig <philipc@snapgear.com>
Date: Fri, 25 May 2007 10:56:10 +1000

> Yasuyuki KOZAKAI wrote:
> > This breaks binary compatibility. The current userspace programs do not set
> > this bit. And ip_checkentry() in all kernel before you change will reject
> > unknown flags from new userspace programs.
> 
> Userspace doesn't need to set it because the kernel can derive it
> automatically (which I've done in ip_checkentry).
> Basically I just needed two bits of internal state, and the flags
> field looked like a convenient place for this.  Userspace should
> be completely ignorant of these bits.

Ah, indeed, thanks for explanation.

-- Yasuyuki Kozakai
