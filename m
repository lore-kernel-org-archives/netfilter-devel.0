From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: iptables u32 match code for review/testing/...
Date: Tue, 7 Jan 2003 22:41:05 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15899.51201.381520.438520@isis.cs3-inc.com>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com>
	<20030106125720.GF9467@sunbeam.de.gnumonks.org>
	<15897.46884.822054.847738@isis.cs3-inc.com>
	<20030107185748.GV9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Don Cohen <don-nf@isis.cs3-inc.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: 
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030107185748.GV9467@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte writes (two separate msgs):
  > /* *** What's this about?
  >    Must fit inside union ipt_matchinfo: 16 bytes */
  What do you mean by this?
That was a comment I found in one of the other match modules
(which I used as a template for this one).
I didn't understand it so I thought I better keep it and flag it.
If you don't know what it's about I guess it's safe to discard it.

  > /* *** any way to allow for an arbitrary number of elements?
  >    for now I settle for a limit of 10 of each */
  no way. At least not with the current kernel/userspace interface :(
Ok, then I'll leave it at 10x10x10 (perhaps a lot of overhead for
a single match?)

 > I like the content (code/implementation/idea of having u32).
 > The only issue is that it doesn't really fit into the current iptables
 > architecture. Why?
 > 	- because it is a whole classification engine on it's own
Why is this bad?  I wrote it to do things I wanted to do but didn't
see how.  I think that's good.  If it subsumes a few others that are
out there, even better.  (But it's almost certainly a lot slower than 
any more specialized match, so they're still useful.)

 > 	- because it has an arbitrary [variable] amount of match data
At the moment, a large fixed amount.  I regard that as a fault of
current iptables, though.

 > Those issues are not possible to resolve, unfortunately.

 ...
 > > Was the indentation a problem?  The tabs were all 8 spaces, but
 > > perhaps you want wider indentation?
 > no, but look at the structure definitions in your header file.
Oops.  The "no" above suggests that you don't mind the narrow
indentation, in which case not only the .h file but the earlier
versions of the .c files were ok except for the few misplaced }'s.

But if you do want wide indentation (and don't mind >80 cols)
then here you go:

====
#ifndef _IPT_U32_H
#define _IPT_U32_H
#include <linux/netfilter_ipv4/ip_tables.h>

enum ipt_u32_ops
{
	IPT_U32_AND,
	IPT_U32_LEFTSH,
	IPT_U32_RIGHTSH,
	IPT_U32_AT
};

struct ipt_u32_location_element
{
	u_int32_t number;
	u_int8_t nextop;
};
struct ipt_u32_value_element
{
	u_int32_t min;
	u_int32_t max;
};
/* *** any way to allow for an arbitrary number of elements?
   for now I settle for a limit of 10 of each */
#define U32MAXSIZE 10
struct ipt_u32_test
{
	u_int8_t nnums;
	struct ipt_u32_location_element location[U32MAXSIZE+1];
	u_int8_t nvalues;
	struct ipt_u32_value_element value[U32MAXSIZE+1];
};

struct ipt_u32
{
	u_int8_t ntests;
	struct ipt_u32_test tests[U32MAXSIZE+1];
};

#endif /*_IPT_U32_H*/
