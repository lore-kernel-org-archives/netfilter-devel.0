From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kill NFC_* stuff in iptables [was Re: iptables compile
 error: NFC_IP_TOS undeclared]
Date: Sat, 12 Feb 2005 02:32:56 +0100
Message-ID: <420D5CC8.1060600@trash.net>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>	<420B8623.9050308@niksula.hut.fi>	<420B9ED0.1020303@trash.net>
	<420BEB36.7080209@eurodev.net> <420D0276.5080200@trash.net>
	<420D27DB.9000608@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <420D27DB.9000608@eurodev.net>
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

Pablo Neira wrote:

> Patrick McHardy wrote:
>
>> Why didn't you remove it entirely instead ?
>
> true :), patch attached. I've gzip'ed it, it's too big for sending it 
> in clear text.

Thanks a lot. Hopeing I don't annoy you .. I haven't actually checked
the API, but can't we remove all those now empty init functions ?
If not I think it would be nicer to change the API to check for
->init == NULL instead of leaving all these empty funtion bodies around.

> Next step, what do you think about removing nfcache passed as 
> parameter from the iptables API?

I don't think we can remove it from struct ipt_entry without
breaking userspace compatibility. But we could stop using it.

Regards
Patrick
