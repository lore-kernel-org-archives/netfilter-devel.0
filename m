From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH 2.6 0/12]: netfilter update
Date: Sun, 26 Sep 2004 23:45:39 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409262344030.7439@filer.marasystems.com>
References: <414F9DFC.701@trash.net> <20040921143611.6a6e2f60.davem@redhat.com>
	<4150BB62.2060904@trash.net> <20040921171857.2c720c8e.davem@redhat.com>
	<4150D880.70108@trash.net> <20040924154032.5a0c32e1.davem@redhat.com>
	<41571BCC.2050909@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41571BCC.2050909@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, 26 Sep 2004, Patrick McHardy wrote:

> Unfortunately I have to agree with you, another set of hooks looks
> like the only way to solve the race. Let me think some more about
> the implications for iptables and ip_conntrack.

conntrack should not see this new hook.

what do do in iptables is a question.. as it is yet another step in the 
packet processing it calls for a new builtin chain I think.

Regards
Henrik
