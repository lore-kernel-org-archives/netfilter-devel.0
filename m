From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] h323 module unloading fix
Date: Wed, 09 Feb 2005 14:34:54 +0100
Message-ID: <420A117E.8080706@trash.net>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
	<420946FF.107@trash.net>
	<20050209082459.GY6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050209082459.GY6878@sunbeam.de.gnumonks.org>
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

>On Wed, Feb 09, 2005 at 12:10:55AM +0100, Patrick McHardy wrote:
>
>>But I think splitting the code to evict expectations and expected
>>conntracks from ip_conntrack_helper_unregister is a cleaner solution.
>>
>
>Mh, but then every author of a helper would explicitly have to take care
>of calling the 'evicting function'.  Considering that any existing
>helper, tutorial and other documentation tells him that he doesn't have
>to, it's easy to get it wrong and introduce further bugs.
>
I meant you should still call it from ip_conntrack_helper_unregister,
but also from the h323 helper. Of course its mostly cosmetic, a comment
before calling unregister is probably just as good.

Regards
Patrick
