From: Patrick McHardy <kaber@trash.net>
Subject: Re: Iptables Match on Direction (IP_CT_IS_REPLY)
Date: Sat, 05 Mar 2005 00:27:08 +0100
Message-ID: <4228EECC.5000504@trash.net>
References: <20050304093542.23600.qmail@web90010.mail.scd.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Peter Lenci <peterlenci@yahoo.ca>
In-Reply-To: <20050304093542.23600.qmail@web90010.mail.scd.yahoo.com>
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

Peter Lenci wrote:
> I studied conntrack but didn't find a way to read the direction
> of the packet. In fact I was thinking about writing a patch for that
> module to add an option "--direction original|reply|both".
> 
> How exactly would you determine the direction with conntrack?

CTINFO2DIR(ctinfo) of ctinfo returned by ip_conntrack_get gives you the
direction. If you want to make a patch for ipt_conntrack it should be
similar to Rusty's recent patch "Add bitops to ipt_MARK without breaking
compatbility".

Regards
Patrick
