From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue.c inefficiencies?
Date: Fri, 04 Feb 2005 06:02:36 +0100
Message-ID: <420301EC.7050002@trash.net>
References: <6.2.0.14.2.20050118185904.047393e0@pop.mindspring.com>
	<20050201131128.GF6878@sunbeam.de.gnumonks.org>
	<4200EF2C.1030808@trash.net>
	<6.2.0.14.2.20050202105005.05278940@pop.mindspring.com>
	<42026FF0.2060602@trash.net>
	<6.2.0.14.2.20050203160902.02ead150@pop.mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Michael StJohns <mstjohns@mindspring.com>
In-Reply-To: <6.2.0.14.2.20050203160902.02ead150@pop.mindspring.com>
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

Michael StJohns wrote:

> At 01:39 PM 2/3/2005, Patrick McHardy wrote:
>
>> We hold queue_lock in your new check for queue_total >= queue_maxlen,
>> so the similar check in __ipq_enqueue_entry will never be true.
>> Therefore I removed it.
>
>
> Makes sense.  I had left it in because I wasn't sure if anyone else 
> was calling it (__ipq_enqueue_entry).  Given the changes, it might 
> actually make sense to eliminate __ipq_enqueue_entry by moving the 
> last two lines of code into ipq_enqueue_entry
>

Yes, I just left it in as counterpart to __ipq_dequeue_entry,
although it would make the code clearer to remove both. Both
functions are inlined, so it doesn't really matter.

Regards
Patrick
