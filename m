From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 15:26:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030126152650.B6811@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <3E33E96A.5080903@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anders Fugmann <afu@fugmann.dhs.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E33E96A.5080903@hipac.org>; from creatix@hipac.org on Sun, Jan 26, 2003 at 02:58:02PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 26, 2003 at 02:58:02PM +0100, Thomas Heinz wrote:
>      - MARK: struct ipt_mark_info {
>                      unsigned long mark, mask;
>                      u_int8_t invert;
>              };
>      - limit: struct ipt_rateinfo {
>                       u_int32_t avg;    /* Average secs between packets 
> * scale */
>                       u_int32_t burst;  /* Period multiplier for upper 
> limit. */
>                      /* Used internally by the kernel */
>                      unsigned long prev;
>                      u_int32_t credit;
>                      u_int32_t credit_cap, cost;
> 
>                      /* Ugly, ugly fucker. */
>                      struct ipt_rateinfo *master;
>               };
> 
>        The unsigned long prev in the middle does not hurt because it
>        is automatically 8 byte aligned by avg and burst. Because
>        the pointer (master) is at the end of the struct it does not
>        cause any problems except that the whole struct must be
>        aligned correctly.

The structure is aligned correctly, however the offsets of the fields,
and sizeof() is different, so it does not work.

> Since I assume that ULOG and MARK work perfectly on sparc64 I must
> be missing something that makes the internal memory layout of the
> structs (i.e. the member offsets) equal in user and kernel space
> (or my assumption is wrong ;-).

Well, I wrote a hack that makes the layout the same, but that's
rather ugly (I call it workaround :).

> It would be kind if someone could fix my brainbug :)
> 
> BTW, pointers and arrays of pointers within target or match
> structs can be forced to have the 8 byte alignment requirement
> (on sparc64 and parisc64) by simply putting them into a
> union: union {void *p; __u64 pad;}

Yes, that's true, except for the fact that you will have to deal
with endianness as well, if you are interested in actually exchanging
data... And don't forget the size change that brings in on every 32-bit
platform effectively killing compatibility...

Regards,
Laszlo


> 
> Regards,
> 
> Thomas
> 
