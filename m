From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: ipt_LOG and friends. Question
Date: Thu, 24 Aug 2006 17:19:23 +0200
Message-ID: <20060824151923.GK31235@kriss.csbnet.se>
References: <20060824140320.GJ31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

2006-08-24 16:03:20+0200, Joakim Axelsson <gozem@gozem.se> ->
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
> 
> What so wrong with using a buffer of say around 1024 chars and a strcat-like
> function (but smarter) keeping track of where to write next and not buffer
> overflowing. And finally printk().
> 
> Like:
> 
> #define MAXLEN 1016
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
> 
> Any problems with this? Have i missed something? Any good reason for calling
> printk() that many times?
> 

Some additional thinking:
The default 29-32 chars as a prefix is far too little for me. Needs to
change to 128. But again i see some code allocating this on the stack. It
this a problem?

The code says that a maximum of 830 chars can be used (ICMP-pcaket with
one recursion level). 128 char prefix and some more on IN, OUT, PHYSIN/OUT
and MAC fields will give an overall figure of around 1024 chars a good
buffer length. Anything above that can probably be cut. It won't happen
alot.

Another idea of not allocating on the stack nor using GFP_ATOMIC is to have
a global buffer per CPU. Is this a good idea with the hot adding and
removing of CPUs? Are linux kernel guarantied to continue on the same CPU if
an interupt occurs and so on? 

--
Joakim Axelsson
