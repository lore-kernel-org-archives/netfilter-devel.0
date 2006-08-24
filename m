From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_LOG and friends. Question
Date: Thu, 24 Aug 2006 18:11:04 +0200
Message-ID: <44EDCF98.2040806@trash.net>
References: <20060824140320.GJ31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060824140320.GJ31235@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> I am writing myself a new/better ipt_LOG (or xt_LOG). I won't go into why i
> am not using ULOG. Its not the point here so.
> 
> Is there some special reason to call printk() in the logging code for every
> little piece of info. This gives a problem when using "Networking console
> logging support" (the netconsole module). Each printk will result in one
> line of log (one UDP-packet) leaving the reiceving syslog-daemon on another
> machine puting several lines of log for each log.
> 
> Also, there is a lock so only one can enter the dump_packet -code in order
> to not get two packets logging at the same time. Locks are costly.

Logging to the ring buffer is not really very suitable for anything but
debugging anyway.

> What so wrong with using a buffer of say around 1024 chars and a strcat-like
> function (but smarter) keeping track of where to write next and not buffer
> overflowing. And finally printk().

That sounds like a good idea. Would you care to send a patch?

> Like:
> 
> #define MAXLEN 1016
>
> struct log_buffer {
> 	char log[MAXLEN]
> 	char *ptr
> }
> 
> /* sizeof(log_buffer) <= 1024, even in 64bits */
> 
> int printlog(struct log_buffer *b, char *fmt, ...) 
> {
> 	if (b->ptr + bytes need writing > log + MAXLEN) {
> 		return error
> 	else {
> 		add string to b->ptr
> 		update b->ptr for next call
> 	}
> }
> 
> 
> This struct should need allocated on stack. This might be a bad idea steal
> that much memory on stack? So we could GPF_ATOMIC allocate it or use one
> global and lock it. I think however that locking is more expensive than
> memory alloc. 

We can't use that much space on the stack, but you can simply keep
the current lock around and use a global structure.
