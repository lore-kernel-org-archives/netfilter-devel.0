From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: find_appropriate_src() BUG also exist in 2.4.24
Date: Mon, 05 Apr 2004 14:44:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081169090.1196.19.camel@nienna.balabit>
References: <20040405122020.40666.qmail@web41705.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: zhi wang <pangy2004@yahoo.com>
In-Reply-To: <20040405122020.40666.qmail@web41705.mail.yahoo.com>
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

On Mon, 2004-04-05 at 14:20, zhi wang wrote:
> Yes, there are different. This bug is because get_unique_tuple blindly accepts
> whatever find_appropriate_src returns in 2.4.x. While 2.6.5 has the return
> tuple checked by ip_nat_used_tuple. You must have know this.:)

  Indeed. This was the cause that the in_range() fix caused problems in
2.4, and had to be backed out.

  Furthermore, I think that find_appropriate_src() is completely useless
in its current form. Note thate src_cmp(), after checking that the
source is the same, passes the source in the original direction as the
manip-to-be-applied to in_range. However, in case of SNAT, this is the
unmodified, original source! I suspect that the destination address in
the reply direction should be used instead, since that value is the new
value applied by NAT on the matching connection. A more detailed
description of the probelem, though somewhat braindump-like, is
available at

http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014418.html

-- 
 Regards,
   Krisztian KOVACS
