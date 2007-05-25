From: Philip Craig <philipc@snapgear.com>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Fri, 25 May 2007 10:56:10 +1000
Message-ID: <4656342A.5040202@snapgear.com>
References: <465528CB.4020108@snapgear.com>
	<200705250044.l4P0i3f8007580@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705250044.l4P0i3f8007580@toshiba.co.jp>
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
> This breaks binary compatibility. The current userspace programs do not set
> this bit. And ip_checkentry() in all kernel before you change will reject
> unknown flags from new userspace programs.

Userspace doesn't need to set it because the kernel can derive it
automatically (which I've done in ip_checkentry).
Basically I just needed two bits of internal state, and the flags
field looked like a convenient place for this.  Userspace should
be completely ignorant of these bits.

> Actually, we cannot add a new flag to 'struct ipt_ip'. It does not have
> revision field. Unfortunately it has no field such as name[] in
> 'struct xt_entry_match' to steal one octet for revision.

If we can never add new flags, then that would be a reason for me to
not bother with clearing the internal bits before sending to userspace.

> I expect that this optimization will be done when we introduce netlink
> interface.

Yes, I'm happy to just keep a local patch until then if you don't think
it is worth it.
