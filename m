From: Thomas Heinz <creatix@hipac.org>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 17:50:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E3411CD.3050603@hipac.org>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <3E33E96A.5080903@hipac.org> <20030126152650.B6811@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Laszlo

You wrote:
>>     - limit: struct ipt_rateinfo {
>>                      u_int32_t avg;    /* Average secs between packets 
>>* scale */
>>                      u_int32_t burst;  /* Period multiplier for upper 
>>limit. */
>>                     /* Used internally by the kernel */
>>                     unsigned long prev;
>>                     u_int32_t credit;
>>                     u_int32_t credit_cap, cost;
>>
>>                     /* Ugly, ugly fucker. */
>>                     struct ipt_rateinfo *master;
>>              };
>>
>>       The unsigned long prev in the middle does not hurt because it
>>       is automatically 8 byte aligned by avg and burst. Because
>>       the pointer (master) is at the end of the struct it does not
>>       cause any problems except that the whole struct must be
>>       aligned correctly.
> 
> The structure is aligned correctly, however the offsets of the fields,
> and sizeof() is different, so it does not work.

Ah yes of course, as the size of unsigned long differs in user and
kernel space every member after prev has a different offset.
So the limit match is a valid example :)

> Well, I wrote a hack that makes the layout the same, but that's
> rather ugly (I call it workaround :).

I just flew over it. Sorry, I must have overlooked it before.

>>BTW, pointers and arrays of pointers within target or match
>>structs can be forced to have the 8 byte alignment requirement
>>(on sparc64 and parisc64) by simply putting them into a
>>union: union {void *p; __u64 pad;}
> 
> Yes, that's true, except for the fact that you will have to deal
> with endianness as well, if you are interested in actually exchanging
> data... 

The only match/target I'm aware of that has a pointer in its info
struct is the limit match. Generally this is necessary for each
match/target that does not treat the info data as read only on a
smp system (at least with the current infrastructure as each cpu has
its own match/target info).

Anyway, I don't see a reason why one wants to exchange a valid pointer
between user and kernel space.

> And don't forget the size change that brings in on every 32-bit
> platform effectively killing compatibility...

One could use #ifdef's for compatibility purpose but as I read you
don't like these :-)


Thomas
