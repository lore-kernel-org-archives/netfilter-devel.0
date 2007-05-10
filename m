From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Thu, 10 May 2007 14:34:00 +0200
Message-ID: <46431138.2080805@trash.net>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>	<46404700.40609@trash.net>
	<200705091105.l49B5DTu023689@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705091105.l49B5DTu023689@toshiba.co.jp>
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
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 08 May 2007 11:46:40 +0200
> 
>>This will add quite some overhead since at least nfct_help is looked at
>>for every packet (we might avoid this using a status flag though).
>>I'm guessing the locks are needed to protect against concurrent
>>reallocations. Maybe we can avoid this by adding the limitation that
>>only unconfirmed entries may add new extensions?
> 
> 
> It sounds good to avoid competition of 2 packet processing. I think
> that the remain is nfctnetlink. It can assign helper to a confirmed
> conntrack. Do you think that it's enough to assume that it disables bh ?


No, that would only help for the CPU its running on. But so far
we only allow to change helpers, not assign completely new ones,
so no reallocation is needed. I'm wondering if this behaviour
is correct though ..
