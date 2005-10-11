From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH/RFC/RFT] add "revision" support to arp_tables and
 ip6_tables
Date: Tue, 11 Oct 2005 22:10:51 +0900 (JST)
Message-ID: <200510111310.j9BDAq7K000720@toshiba.co.jp>
References: <20051009222628.GC6593@rama.customers.eurospot.com>
	<434A373B.1060406@gmx.net> <20051010163256.GB5627@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051010163256.GB5627@rama>
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

From: Harald Welte <laforge@netfilter.org>
Date: Mon, 10 Oct 2005 18:32:56 +0200

> On Mon, Oct 10, 2005 at 11:41:15AM +0200, Carl-Daniel Hailfinger wrote:
> 
> > >[NETFILTER] {ip6,arp}_tables: Add support for match/target revisions
> > >This patch synchronizes {ip6,arp}_tables with recent changes in ip_tables.
> > >It adds support for multiple revisions per match/target.
> > >diff --git a/include/linux/netfilter_arp/arp_tables.h 
> > >b/include/linux/netfilter_arp/arp_tables.h
> > >--- a/include/linux/netfilter_arp/arp_tables.h
> > >+++ b/include/linux/netfilter_arp/arp_tables.h
> > >@@ -68,7 +68,8 @@ struct arpt_entry_target
> > > 			u_int16_t target_size;
> > >  			/* Used by userspace */
> > >-			char name[ARPT_FUNCTION_MAXNAMELEN];
> > >+			char name[ARPT_FUNCTION_MAXNAMELEN-1];
> > >+			u_int8_t revision;
> > > 		} user;
> > > 		struct {
> > > 			u_int16_t target_size;
> > 
> > This will explode once revision!=0 because the string stored in name is not NULL-terminated 
> > anymore if it is ARPT_FUNCTION_MAXNAMELEN-1 long.
> 
> Are you referring to something specific inside arp_tables kernel or
> userspace code?  We had a similar change in ip_tables some time ago, and
> just made sure that the userspace program ("iptables") didn't generate
> any strings longer than IPT_FUNCTION_NAMELEN-2.  Since we never had any
> matches or targets that used the full length, there is no problem.  
>
> At least inside the mainline kernel, I cannot see any targets/matches
> for ip6_tables or arp_tables that actually have 30 characters of length.

I think that the point of issue what Carl want to say is size of "name".
He worries about that the memory address of "revision" became different
in the kernel and userspace.

I think the change like this is invalid in logical as Carl said, but there
might be no problem in real by help of alignment in this time.
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
