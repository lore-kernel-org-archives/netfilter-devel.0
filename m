From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] ctnetlink: Fix NAT info setting.
Date: Thu, 01 Dec 2005 14:38:48 +0100
Message-ID: <438EFCE8.1090505@ingate.com>
References: <438EEF0E.60206@ingate.com> <438EF925.4050802@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <438EF925.4050802@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Marcus Sundberg wrote:
> 
>>[NETFILTER] ctnetlink: Fix NAT info setting.
>>
>>ip_nat_initialized() takes enum ip_nat_manip_type as it's second
>>argument, not a hook number. The current code was not only ugly,
>>but also broken as IP_NAT_MANIP_SRC != NF_IP_POST_ROUTING.
> 
> Thanks for the bugfix but I don't like it, it's a bit bloated. Harald,
> please submit the patch attached. It uses HOOK2MANIP macro instead.

Ah, I wasn't aware of that macro. I agree that's a nicer fix.

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
