From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3][CTNETLINK] Atomically set/unset status bits
Date: Wed, 29 Nov 2006 15:59:35 +0100
Message-ID: <456DA057.4090308@netfilter.org>
References: <456C7606.4020504@netfilter.org> <456C806B.9060806@netfilter.org>
	<456CB8AD.8090809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <456CB8AD.8090809@trash.net>
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
> We already hold the lock, what is the purpose of this change?
>
> It also changes the API, so far bits can only be set. I wonder
> where this comes from, I'm pretty sure my original code allowed
> to unset specific bits and the checks at the top of that function
> indicate that unsetting is possible as well.

Just a minor digest on this issue:

Leyend:
U = unchangeable
S = can be set
C = can be cleared

IPS_EXPECTED            U
IPS_SEEN_REPLY          S
IPS_ASSURED             S
IPS_CONFIRMED           U
IPS_NAT_MASK            U
IPS_SEQ_ADJUST          U
IPS_NAT_DONE_MASK       U
IPS_DYING               U
IPS_FIXED_TIMEOUT       S,C
IPS_PICKUP              S,C
IPS_IN_WINDOW           S,C

You are right, the lock is enough for most of them, actually my concern
is the new IPS_PICKUP that can be cleared by the TCP tracking code once
the pickup happens, such code is called outside the lock in proto->packet().

BTW, I just noticed that there are not checkings for SEQ_ADJUST, should
we add one?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
