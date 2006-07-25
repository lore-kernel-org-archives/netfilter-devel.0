From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/8] ctnetlink updates incarnation #2
Date: Tue, 25 Jul 2006 15:17:07 +0200
Message-ID: <44C619D3.5040306@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi,

Here follows the #2 incarnation of the ctnetlink updates:

[CONNTRACK] mark conntrack event
[CTNETLINK] dump conntrack mark
[CTNETLINK] send expectation events iif there listeners
[CTNETLINK] Fix race condition on conntrack creation
[CONNTRACK] Introduce the pickup facilities to take over TCP connections
[CTNETLINK] Rework conntrack fields dumping logic on events
[CTNETLINK] send conntrack events on ctnetlink actions
[CTNETLINK] Remove useless event-bit-is-set checkings on updates

Patches 1-3 are trivial, Patrick was OK with them. Patches 4-8 are based 
on their previous incarnation plus Patrick's suggestions.

I'll be leaving to Valencia and Barcelona tomorrow but I think that I'll 
have an internet connection up to August 1st.

Comments welcome.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
