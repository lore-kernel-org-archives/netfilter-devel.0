From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/22]: Netfilter update/fixes
Date: Mon, 12 Feb 2007 11:17:25 -0800 (PST)
Message-ID: <20070212.111725.74748844.davem@davemloft.net>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 12 Feb 2007 11:36:21 +0100 (MET)

> Hi Dave,
> 
> following are a number of fixes for netfilter, fixing RCU issues all over the
> place, including the invalid preemption assumptions in the NF_CT_STAT_INC macro.
> Additionally there are a few minor enhancements for things I noticed while going
> over the code: replacement of a few unnecessary spinlocks by mutexes, some
> cleanup for nf_log.c and some return value cleanup for unregistration functions.
> 
> With these patches I think there should be nothing left holding back the
> preemptable RCU merge from netfilter's perspective.
> 
> Please apply, thanks.

Thanks a lot for doing this work Patrick.

All applied, thanks again.
