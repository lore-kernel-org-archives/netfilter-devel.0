From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch for conntrack expectations
Date: Thu, 04 Mar 2004 00:50:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40466F35.3080709@trash.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org> <403B1F5F.6010004@trash.net> <20040224102432.GX13386@sunbeam.de.gnumonks.org> <403B7CAA.3060005@trash.net> <403CD128.40101@eurodev.net> <404668EB.1080400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <404668EB.1080400@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

One more suggestion, sorry for not bringing this up earlier.
ip_conntrack_expect_alloc() takes a pointer to the pointer
to assign the memory to and returns -ENOMEM/1, why not just
return the pointer ? Besides being what I would expect from
an _alloc-function it helps gcc generate better code because
it assumes comparisons with NULL unlikely to be true.

Regards,
Patrick

Patrick McHardy wrote:
> Hi Pablo,
> this patch is not correct as far as I can see. With your new API,
> ip_contrack_expect_related owns the memory after beeing called.
> The cleaned up amanda helper reuses the same memory for all
> expectations and expects ip_conntrack_expect_related to allocate
> new memory and copy the data, so this will result in corruption.
> It also leaks memory if the loop is left early. One thing that
> seems to affect all changed helpers, you return -ENOMEM when
> ip_conntrack_expect_alloc() fails, in this case while holding
> a lock. You should return NF_DROP instead.
> 
> Can you please send a new patch ?
> 
> Regards
> Patrick
> 
> Pablo Neira wrote:
> 
>> Attached my patch for the patrick's amanda helper to use the new 
>> expect_alloc api.
>>
>> Pablo
