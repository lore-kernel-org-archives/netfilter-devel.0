From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: POM conditional parts
Date: Fri, 28 Nov 2003 13:52:39 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311281348240.6776-100000@filer.marasystems.com>
References: <3FC73F50.3050700@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <3FC73F50.3050700@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 28 Nov 2003, KOVACS Krisztian wrote:

>    So, if I'd like to prepare a POM patch which changes 
> ip_nat_used_tuple(), it breaks other patches (for example GRE NAT). So, 
> I'd need some "conditional patches" functionality, e.g. parts of the NAT 
> reservation patch should be applied only if some other patch is applied... 
> AFAIK, this is not possible with current POM. Any ideas?

You then need to split the patch in two and use dependencies to get the 
relations correct.

Regards
Henrik
