From: Pablo Neira <pablo@eurodev.net>
Subject: Re: libipq: man page != online doc and a question
Date: Sat, 16 Oct 2004 18:29:04 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41714C50.8060400@eurodev.net>
References: <20041015192145.383e8bd9.tigrezno@log01.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jvalencia <tigrezno@log01.org>
In-Reply-To: <20041015192145.383e8bd9.tigrezno@log01.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jvalencia wrote:

>I've been looking at ipq_set_verdict man page, finding two verdicts: NF_ACCEPT and NF_DROP.
>  
>

correct

>This man page dates from 2001 :S
>
>Online netfilter hacking guide tells about NF_ACCEPT, NF_DROP, NF_QUEUE and NF_REPEAT.
>  
>

yes, these are all possibles verdicts in a *kernel hook*, not in ip_queue

>Can I send the packet to another chain with verdicts?
>  
>

what do you mean?

regards,
Pablo
