From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6] connection tracking events
Date: Sat, 16 Oct 2004 15:21:06 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41712042.2000505@trash.net>
References: <20041015175406.GK17516@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041015175406.GK17516@obroa-skai.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Harald Welte wrote:

>Hi!
>
>Since we decided at the netfilter developer workshop that we want to
>split conntrack events from the rest of ctnetlink, I've now done that
>(and ported it to use percpu allocations).  This is needed mostly for 
>ct_sync.
>  
>
I've already did this in Erlangen. Pablo is currently working with
Krizstian on this patch.

>Totally untested, but seems to compile.  Comments welcome.
>
>As it is quite non-intrusive, I think we should consider it for
>post-2.6.9.
>  
>
Agreed.

Regards
Patrick
