From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: what's the lockingrules for ip_conntrack_expect_list?
Date: 10 Oct 2002 23:40:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034286048.25146.40.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
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

I've been going through the latest bugreport about failed ASSERT's...
It's the usual suspects, exp_for_packet that calls ip_ct_find_proto
instead of __find_proto, this isn't a bug, it's just that the
debug-macros can't handle it, we've been over this before...

But here's the real question...
What's the lockingrules for ip_conntrack_expect_list?

I've gone through 2.4.20-pre8aa2 which was the kernel the bugreport was
from. And I've found some inconsistencies.

here's a list of all functions that deals with ip_conntrack_expect_list
and which locks they are holding when they do so, and the specific
operation they perform on the list.


ip_conntrack_expect_find_get 
	READ_LOCK(&ip_conntrack_lock);
	READ_LOCK(&ip_conntrack_expect_tuple_lock);
	__ip_ct_expect_find
		MUST_BE_READ_LOCKED(&ip_conntrack_lock);
		MUST_BE_READ_LOCKED(&ip_conntrack_expect_tuple_lock);
		LIST_FIND

death_by_timeout
	WRITE_LOCK(&ip_conntrack_lock);
	clean_from_lists
		MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
		remove_expectations
			list_inlist

init_conntrack
	first:
		WRITE_LOCK(&ip_conntrack_lock);
		READ_LOCK(&ip_conntrack_expect_tuple_lock);
		LIST_FIND
	later: 
		WRITE_LOCK(&ip_conntrack_lock);
		LIST_DELETE

ip_conntrack_expect_related
	WRITE_LOCK(&ip_conntrack_lock);
	LIST_FIND
	LIST_FIND
	list_prepend

ip_conntrack_change_expect
	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
	LIST_FIND

	FAILS!! called from nat-helpers which only hold their own locks 	if any
at all.


So what's the story? sometimes we hold only ip_conntrack_lock and
sometimes we hold that plus ip_conntrack_expect_tuple_lock and now I've
found out that sometimes we never hold any lock.

Give me a hint and I'll write up a patch to fix it.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
