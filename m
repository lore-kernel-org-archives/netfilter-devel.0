From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 21:21:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9435BC.8020407@trash.net>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com> <3F934FFD.7090700@trash.net> <20031020071545.GA21521@sunbeam.de.gnumonks.org> <3F9426C1.6070908@trash.net> <20031020183954.GC20288@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031020183954.GC20288@sunbeam.de.gnumonks.org>
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

>On Mon, Oct 20, 2003 at 08:17:37PM +0200, Patrick McHardy wrote:
>
>  
>
>>I still favour the global counter but I'm fine as long as dumping works, 
>>a unqiue identity for userspace is less important. I'd say it's up to
>>you to decide.
>>    
>>
>
>Mh, well let's go for the 64bit, as there seems to be no other choice.
>But we should start working on the variable-sized conntracks within
>short time afterwards.
>

I actually already started it some time ago but it had to step back for
more interesting things ;) Maybe we can place the global counter next to
some other value that is modified anyways at conntrack creation so they
will be in the same cache line. ip_conntrack_count comes to mind but
unfortunately it's atomic_t (volatile).

Best regards,
Patrick
