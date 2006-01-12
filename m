From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] ctnetlink: Make expect events work
Date: Thu, 12 Jan 2006 22:11:24 +0100
Message-ID: <43C6C5FC.6030705@ingate.com>
References: <43C6A946.5070009@ingate.com> <43C6C418.6060104@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43C6C418.6060104@trash.net>
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

Patrick McHardy wrote:

> Marcus Sundberg wrote:
> 
>> [NETFILTER] ctnetlink: Make expect events work
>>
>> The ctnetlink expectation events should use the NFNL_SUBSYS_CTNETLINK_EXP
>> subsystem, not NFNL_SUBSYS_CTNETLINK.
> 
> Thanks, applied with the same change in nfnetlink_conntrack.
> For future patches please also check if bugs are present in
> nfnetlink_conntrack.

Thanks for the reminder, didn't even think about nfnetlink_conntrack.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
