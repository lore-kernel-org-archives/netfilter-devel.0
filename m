From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 21:17:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9434BC.5000508@trash.net>
References: <Pine.LNX.4.44.0310201133040.23768-100000@filer.marasystems.com> <3F942CB6.5060005@trash.net> <20031020183741.GB20288@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031020183741.GB20288@sunbeam.de.gnumonks.org>
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

>On Mon, Oct 20, 2003 at 08:43:02PM +0200, Patrick McHardy wrote:
>
>  
>
>>>The dump operation should be connetion oriented with the userspace 
>>>application, not purely datagram based. The kernel should know for certain 
>>>if the userspace application terminates a dump operation mid-air.
>>>
>>>      
>>>
>>Actually the kernel knows. If the socket is closed cb->done() is called.
>>However the kernel can not know if userspace still keeps the socket open
>>but doesn't read anymore. Connection oriented sockets don't help with this.
>>    
>>
>
>yes, but if the application is broken, that's not our problem.  If the
>API and the behaviour is documented, I don't see any problems with this.
>If an app wants to intentionally allocate many opjects in kernel space,
>there's nothing we can do.  Also, since we are sending to userspace, we
>could actually allocate this as virtual memory, right?
>

Yes I just mentioned it to clarify the problem with allocating memory and
freeing it in ctnetlink_done() and point out that connection oriented
sockets don't help. I'm not sure what you mean with "allocate as virtual
memory", do you mean accounting the memory to the process which started
the dump ? I'm not sure how the conventions with accounting kernel memory
are, but at least that would provide a way to bound the amount of memory
that can be used in case we decide to use a solution which requires dynamic
allocations.

Best regards,
Patrick
