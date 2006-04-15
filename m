From: Patrick McHardy <kaber@trash.net>
Subject: Re: compat_xt_counters is not compatible
Date: Sat, 15 Apr 2006 18:37:22 +0200
Message-ID: <44412142.9070409@trash.net>
References: <jeacaoqdxn.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <jeacaoqdxn.fsf@sykes.suse.de>
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

Andreas Schwab wrote:
> struct compat_xt_counters uses uint32_t[4], which has 4 byte alignment,
> but userspace uses uint64_t[2], which has 8 byte alignment.  This breaks
> iptables in 2.6.17-rc1.

Did you actually see the breakage? gcc on x86 uses 8 byte alignment for
u_int64_t, but 4 byte alignment for structures with embedded u_int64_t
members. It appears to work just fine on my x86_64.
