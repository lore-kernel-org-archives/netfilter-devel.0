From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: MARK target extension
Date: Thu, 10 Jun 2004 11:59:35 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406101129490.13398-100000@filer.marasystems.com>
References: <20040609222646.M64@metal.art.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grzegorz Nosek <blackfire@metal.art.pl>
In-Reply-To: <20040609222646.M64@metal.art.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 10 Jun 2004, Grzegorz Nosek wrote:

> Taking this a little bit further, why not get rid of the /mask
> entirely as it's not exactly obvious what it means and replace them
> with more verbose --set-mark, --or-mark, --and-mark, --xor-mark?

Because the mask is far more powerful in the --set-mark.

--or-mark makes sense to add as an alternative human representation as
0x80/0x80 is not very intuitive unless one is used to work with masked
values, and even more so if value/0 is reserved for xor (mask 0 in
CONNMARK is today or, regardless of the value)

--and-mark also makes sense to add as an alternative representation of 
0/value

but both --or-mark and --and-mark can be represented in --set-mark by the
logics of --set-mark. It is only --xor-mark which can not.


> It would look like the mark-operations patch but should allow for
> multiple operations per line. --set-mark would prohibit any other
> options, --and-mark would be performed before --xor-mark. --or-mark
> would end up as a xor and a change to the and mask, as in: xor_mark =
> or_mark; and_mark = and_mark & ~or_mark; /* or something, I'm asleep
> right now */

If you like the userspace can allow for multiple and/or/set operations (in
any order). xor is exclusive with the other operations however unless the 
representation is extended with one more bitfield for xor.

> One side effect would be that upon iptables-save, all ORs would change
> to XORs "mysteriously" but there might be a way to detect ORs and
> treat them as such (xor_mask & and_mask == 0 or thereabouts).

Eh?

xor is a special case and will always be xor. xor can not be combined with 
anything else without extending the representation, and if the 
representation is extended xor is still cleraly separate from the other 
operation.

With the following binary representation and kernel function any
combination of set/and/or/xor can be represented:

  unsigned long value, mask, xor;


  newvalue = ((oldvalue & mask) | value) ^ xor;

or alternatively

  newvalue = ((oldvalue ^ xor ) & mask ) | value)


Userspace operations:


  --set-mark

      value |= specified_value;
      if (mask specified)
          mask |= specified_mask;
      else
          mask = ~0;

  --or-mark

      value |= specified_value;
      mask |= specified_value;

  --and-mark becomes

      if (mask = 0)
          mask = ~0;
      mask &= specified_value;

  --xor-mark becomes

      if (mask = 0)
          mask = ~0;
      xor |= specified_value;



If you like there can be appropriate asserts to alert the user if he is 
specifying conflicting operations on the same bit, but I am not sure if 
this is needed other than for xor.

Regards
Henrik
