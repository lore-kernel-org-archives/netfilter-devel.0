From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [HELP] what is the semantic meaning of find_appropriate_src()?
Date: Tue, 02 Mar 2004 12:20:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078226407.821.117.camel@nienna.balabit>
References: <OF87010E92.B8DC3ACD-ON48256E4B.002B8F90@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: wanghtb@legend.com.cn
In-Reply-To: <OF87010E92.B8DC3ACD-ON48256E4B.002B8F90@legend.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Tue, 2004-03-02 at 08:56, wanghtb@legend.com.cn wrote:
> I tried  the UDP SNAT, but it still  do not work: find_appropriate_src() 
> do not
> find the proper manip.
> 
>  [Client A ] -----> [Box B ]   -----> [Server C]
>  
>  and the rule is: iptables -t nat -A POSTROUTING -p udp -j SNAT 
> --to-source B
>  
> consider two udp sessions: 
> i)  A.1 ---> C.1 
> ii) A.1 ----> C.2
> 
> when first udp session packet passes through Box B,
> ct1: ORIG A.1--->C.1  REPLY C.1--->B.1
> all is ok as we expected:-)
> 
> However, when the second udp session packet arrives Box B:
> at PRE_ROUTING hook, new ct is builded for it:
> ct2: ORIG A.1---->C.2 REPLY C.2 ---> A.1
> and at POST_ROUTING, find_appropriate_src()is called, and
> the content of mr will be to set new src_ip as  B.
> 
> Just a quick check of code, the result coincides with 
> the implementation of the function: the in_range() will
> always returnes false in the example.

  Oops, you're right. However, I don't think this is the intended
operation of find_appropriate_src(), I suspect this is a bug. The
problem seems to be the following:

1. ip_nat_setup_info() passes the inverse of the reply tuple to
get_unique_tuple() as orig_tuple, in our case this will be the same as
the tuple in the original direction (A.1 -> C.2). mr will be set to
MANIP_SRC to B. 

2. get_unique_tuple() calls find_appropriate_src() with orig_tuple and
mr.

3. find_appropriate_src() traverses the appropriate hash chain,
returning the first list entry for which src_cmp() returns true.

4. src_cmp() gets the following arguments: the current nat hash entry,
orig_tuple, and mr. It compares the list entry's ORIG_DIR source to
orig_tuple's source. In our case this matches. Then it calls in_range()

5. in_range() gets the following arguments: orig_tuple, ORIG_DIR source
of the current list entry as the manip, and mr. It constructs newtuple:
the source will be current conntrack's ORIG_DIR's source, the
destination that of orig_tuple. Note that orig_tuple is the same as the
to-be-NAT-ed connection's ORIG_DIR tuple, and the conntrack's source
must be equal, if in_range() is called by src_cmp(). However, in this
case, in_range returns false, because newtuple's source IP (A) won't be
the same as that given by mr (B).

  So, in our case in_range() does not apply the source manip to
orig_tuple, because src_cmp() passes the wrong manip to it. Maybe
src_cmp() should pass

&i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst
instead of
&i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src

as manip to in_range()? I think it would make more sense, since we are
interested in the probably matching connection's NAT-ed source.

  This change is still not enough in our example. The following patch
was proposed for inclusion into the Linux kernel before the 2.4.23
release, however, it was rolled back since there were problems reported
when it was applied. (See 
http://lists.netfilter.org/pipermail/netfilter-devel/2003-November/013099.html) As a side note: this patch went into Linux 2.6, it was rolled back only in Linux 2.4. Doesn't it cause stability problems there?

--- linux-2.4.23-pre3/net/ipv4/netfilter/ip_nat_core.c	2003-11-08 
03:01:59.000000000 -1000
+++ linux-2.4.23-pre4/net/ipv4/netfilter/ip_nat_core.c	2003-11-08 
03:00:47.000000000 -1000
@@ -157,8 +157,8 @@
 				continue;
 		}
 
-		if ((mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    && proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
+		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
+		    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
 				       &mr->range[i].min, &mr->range[i].max))
 			return 1;
 	}

  The patch is obviously correct, as the old code fails to return 1 if
the IP_NAT_RANGE_PROTO_SPECIFIED flag is not set in the range flags.
However, for this code to be run, there must be some case when in_range
finds matching IP addresses, and goes on to check the per-protocol part.
This can happen only when a connection is NAT-ed to the same address as
its original address. As Karlis Peisenieks reported
(http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012368.html), this is the case for null-mappings. Because in this case the NAT entry maps the original source/dest IP to the same IP, src_cmp() will pass the correct manip to in_range(), and thus the code above will decide if find_appropriate_src() will find a matching NAT entry. Without the in_range() fix, it won't match, since IP_NAT_RANGE_PROTO_SPECIFIED is not set for null-mappings. However, with the fix, it will, thus possibly creating problems. (As in Karlis' case.)

  So I'm a bit confused. I think src_cmp() is buggy. However, I don't
understand how the in_range() fix could cause problems in 2.4, if it
works in 2.6...

-- 
 Regards,
   Krisztian KOVACS
