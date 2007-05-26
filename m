From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Sat, 26 May 2007 11:20:20 +0200
Message-ID: <4657FBD4.80506@trash.net>
References: <465528CB.4020108@snapgear.com>	<200705250044.l4P0i3f8007580@toshiba.co.jp>
	<4656342A.5040202@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Philip Craig <philipc@snapgear.com>
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

Philip Craig wrote:
> Yasuyuki KOZAKAI wrote:
> 
>>Actually, we cannot add a new flag to 'struct ipt_ip'. It does not have
>>revision field. Unfortunately it has no field such as name[] in
>>'struct xt_entry_match' to steal one octet for revision.
> 
> 
> If we can never add new flags, then that would be a reason for me to
> not bother with clearing the internal bits before sending to userspace.


We can add flags for new features, but not flags that are required to
be set to behave compatible since that would break iptables userspace
for old kernels.
