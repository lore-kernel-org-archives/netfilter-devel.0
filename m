From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: pptp patch breaks nat-reservation patch (on ppc-machines)
Date: Fri, 09 Jul 2004 12:57:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089370621.11589.11.camel@nienna.balabit>
References: <BDEHJGPIKNLKJJBCCFPLOEIOCOAA.listuser@sally.epygi.de>
	 <40EE60D9.1090608@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <40EE60D9.1090608@snapgear.com>
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

2004-07-09, p keltezéssel 11:09-kor Philip Craig ezt írta:
> Where exactly in the nat reservation patch is the problem?  I
> couldn't see anything that would cause an alignment problem, although
> there were a few debug statements that were passing u.all to ntohs().
> I think those debug statements should use DUMP_TUPLE() instead.
> 
> The other thing I noticed is that some places treat manip.u.all and
> tuple.dst.u.all as the same size, which is wrong.  tuple.dst.u.all is
> actually 64 bits with the pptp patch.  clashing_ct_cmp()  incorrectly
> compares them, and _ip_nat_reserved_new_hash() creates a tuple based
> on a manip.
> 
> I think invert_tuplepr() can be used to fix both of these, although
> I haven't looked too closely.  Basically, you need to call the
> invert_tuple() function from ip_conntrack_protocol, since it is the
> only thing that knows how to invert correctly.

  You're right, of course. I'll prepare a fix for nat-reservations as
soon as I'll have time to do so. However, I'd need someone competent to
review the fixes.

-- 
 Regards,
   Krisztian KOVACS
