From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 12:01:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030126120159.A3045@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E335CB1.9070101@hipac.org>; from creatix@hipac.org on Sun, Jan 26, 2003 at 04:57:37AM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 26, 2003 at 04:57:37AM +0100, Thomas Heinz wrote:
> Conclusions:
> 
> Except for struct tptr both sparc64 and alpha have the same struct
> alignment and member offsets for all structs.

This is not too surprising. Both of them are RISC processors with
strict alignment restrictions. I guess even with a 32bit sparc
gcc, a 64bit unsigned integer gets aligned to 64bit just to make life
easier (I'm not sure if there's a 64bit load instruction on 32bit sparc's).

> struct tptr is different because sizeof(void *) is different on alpha
> and sparc64 (in user space).
> 
> Now, imagine that only those structs were allowed for which the
> following properties hold:
>              - basic datatype must be of fixed width (e.g. __u8, __u16,
>                __u32, __u64)
>              - members of the struct can be of:
>                   * basic type
>                   * array of basic type
>                   * array of struct (for which the same properties hold)
>                   * struct (for which the same properties hold)
> 
> In this case the IPT_ALIGN macro is _not_ needed!
>
> So I come to the conclusion that if no pointers within target or match
> structs would be needed IPT_ALIGN can be dropped without any
> problems (if the assumption about the basic datatype holds).
> 
> What do you think about this? Am I wrong/right? Do I miss anything?
> Is the stuff stated above trivially obvious ;-)?

You missed one point (currently (ab)used by netfilter):

* structures which are "put" next to each other (eg: ipt_replace and
  ipt_entry) must be examined carefully for alignment problems.

Otherwise you are right.

But this "put" next to each other thing can be rather nasty.

You can be sure a structure is padded at the end by the compiler to
whatever alignment is necessary for that structure. So if you have
a 64bit integer in it, it will be padded at the end to 64bit. To
ensure that arrays of that structure work.

Now the problem comes if you have only 32bit integers in the first
structure and 64bit integers in the second one: you have to either
use IPT_ALIGN again (which we would like to get rid of), or we
have to make sure the first structure gets aligned to 64bit.
We could introduce an extra variablke just for this at the end
like:

	u_int64_t dummy[0];
}

Or we could do something like that in netfilter:

	struct ipt_entry entries[0];
}

This latter version is better if we know what kind structure will follow,
because it will not increase the size of the structure unnecessarily on
platforms without alignment restrictions.

Regards,
Laszlo
