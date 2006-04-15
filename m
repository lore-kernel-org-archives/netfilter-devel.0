From: Dmitry Mishin <dim@sw.ru>
Subject: Re: compat_xt_counters is not compatible
Date: Sat, 15 Apr 2006 18:11:53 +0400
Message-ID: <200604151811.54013.dim@sw.ru>
References: <jeacaoqdxn.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andreas Schwab <schwab@suse.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <jeacaoqdxn.fsf@sykes.suse.de>
Content-Disposition: inline
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

compat_xt_counters should be used only for 32bit processes, which has 4 byte 
alignment.

On Friday 14 April 2006 21:12, Andreas Schwab wrote:
> struct compat_xt_counters uses uint32_t[4], which has 4 byte alignment,
> but userspace uses uint64_t[2], which has 8 byte alignment.  This breaks
> iptables in 2.6.17-rc1.
>
> Andreas.

-- 
Thanks,
Dmitry.
