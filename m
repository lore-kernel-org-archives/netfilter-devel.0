From: Patrick McHardy <kaber@trash.net>
Subject: Re: RAM and conntrack performance: first draft of the document is
 online
Date: Wed, 26 Nov 2003 17:26:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC4D429.3050401@trash.net>
References: <20031028151032.GD726@eychenne.org> <20031103081240.GQ1536@sunbeam.de.gnumonks.org> <20031125153543.GD1082@eychenne.org> <20031125205723.GE2971@obroa-skai.de.gnumonks.org> <20031126034231.GA1044@eychenne.org> <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herve Eychenne <rv@wallfire.org>,
 Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031126113645.GF3121@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>>Don't you think it would be good to shrink the lists immediately?
>>Waiting til the number has dropped below the limit can take days...
>>    
>>
>
>well, it might be a good idea.  but I somehow doubt this is a valid
>scenario.  And if we would shrink the list:  how do we select which
>entries to evict?  I'd rather wait for ctnetlink to appear in mainstream
>kernels and then leave that to a userspace process.
>  
>

PF uses "adaptive timeouts" to scale down timeouts if the table gets full.
IIRC until some threshold is reached, all entries have 100% of their normal
timeouts, from then on its scaled down until 0% for a completly full table.
I've been thinking about adding this to ip_conntrack for some time because
I often have problems with my roommates edonkey and overflowing conntrack
table. I decided to experiment with it when the timeout handling of conntrack
is changed from beeing handled by a per-conntrack timer to a global cleanup
timer. I recall someone wanted to make a patch for this some time ago to
prevent timer storms, do you have any information if anyone is currently
working on this ? Otherwise I might just do both ..

Best regards,
Patrick
