From: Patrick McHardy <kaber@trash.net>
Subject: Re: ACCOUNT target future (pkttables)
Date: Sun, 03 Apr 2005 20:31:28 +0200
Message-ID: <42503680.10302@trash.net>
References: <424A7C63.1050705@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
In-Reply-To: <424A7C63.1050705@gmx.net>
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
> Hi,
> 
> I'm currently writing an ACCOUNT target for ebtables and I feel really
> uncomfortable in duplicating the existing iptables ACCOUNT code, adding
> a few tweaks and releasing it as ebtables ACCOUNT target. The tweaks
> would be:
> - efficient handling of sparsely poulated networks
> - accounting by MAC address
> - 64bit counters (optional)
> - saturated counters (optional)
> - choice of what to count (layer 2/3 length, packets, src/dst)
> 
> Some time ago, I found notes from a netfilter developer workshop about
> future directions (reducing code duplication, switching to pkttables...)
> and my work would counteract your plans to reduce code duplication. Is
> there any working code using the new framework and does it make sense
> for me to write my code only for the new framework (will that be merged
> eventually into mainline)?

There is none (or almost none, not sure) pkttables code yet. A better
approach than duplicating everything is to split out the core and make
it useable by both modules. BTW, have you looked at the tc action
API? It may be better suited because all traffic passes through it.

Regards
Patrick
