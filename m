From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue.c inefficiencies?
Date: Wed, 02 Feb 2005 16:18:04 +0100
Message-ID: <4200EF2C.1030808@trash.net>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
	<20050201131128.GF6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Michael StJohns <mstjohns@mindspring.com>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201131128.GF6878@sunbeam.de.gnumonks.org>
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

>On Tue, Jan 18, 2005 at 07:18:32PM -0500, Michael StJohns wrote:
>
>>The patch below does two things:  It adds some /proc visible counters to 
>>count the packets dropped because they couldn't be queued to either kernel 
>>or user space; it adds a check early on in ipq_enqueue_packet to check and 
>>see if the kernel queue is full before trying to send the packet to user 
>>space.
>>
>
>I think your patch is perfectly valid and looks fine.  
>
>Patrick, if you don't see any problems, could you add it to your queue
>of pending patches? Thanks!
>
The patch doesn't apply to current -bk. Michael, can you please send a new
patch against the latest -bk kernel ?

Regards
Patrick
