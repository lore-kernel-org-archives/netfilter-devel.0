From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] h323 module unloading fix
Date: Wed, 09 Feb 2005 00:10:55 +0100
Message-ID: <420946FF.107@trash.net>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>Hi!
>
>If you unload the ip_conntrack_h323 module while a h323 session is in
>progress, the conntrack table is left with corrupted entries (->helper
>pointer still pointing to a now no longer existing h245 helper).
>
>This is because the h245 helper is not registered with the core, and
>therefore the helper_unregister() function will only be called for h245,
>but not for h245.
>
>The proposed solution:
>
>1) to make ip_conntrack_core:ip_conntrack_helper_unregister() work with
>   a helper that was never registered (and thus has an empty list.next)
>2) to have ip_conntrack_h323 unregister the h245 helper.
>
>Any comments?
>
You can initialize helper->list and replace LIST_DELETE by list_del, 
then you
can avoid the check for list.next. But I think splitting the code to evict
expectations and expected conntracks from ip_conntrack_helper_unregister is
a cleaner solution.

Regards
Patrick
