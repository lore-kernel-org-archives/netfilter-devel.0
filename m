From: Bryan Cardillo <dillo@seas.upenn.edu>
Subject: expire module issue
Date: Wed, 6 Jul 2005 13:30:23 -0400
Message-ID: <20050706173023.GA3586@rover.pcbi.upenn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

        I'm having a problem with the expire module I submitted a
        few days (weeks, maybe?) ago.  The observed behavior is that
        expired rules cannot be deleted from built-in chains.  I
        think the issue is related to deleting a rule (ipt_entry)
        without fixing hook_entry / underflow to reflect the deleted
        rule.

        My understanding of hook_entry / underflow is limited, so
        maybe someone can enlighten me.  For those who haven't
        studied the code, the basic idea is to approximate
        `iptables -D' for the expired rule.  So, the pseudo-code
        goes something like this:

        nf_getsockopt(IPT_GET_INFO)
        nf_getsockopt(IPT_GET_ENTRIES)
        for each entry in (entries)
            if (not(is_expired(entry)))
                copy(replace->entries[i++], entry)
        nf_setsockopt(IPT_REPLACE)

        now, this works fine for user-defined chains with no jumps,
        but thats it.  I've tried adding code to subtract the size
        of the expired entries from hook_entries which are past the
        entry address.  this gets me past the hook_entry
        check in do_replace, only to get flagged as a loop in
        mark_source_chains.
        
        I've been using the iptables libiptc code as a guide for
        implementing the rule deletion, but since this is strictly a
        deletion, I'd rather not put the entire ruleset parsing and
        compilation code in the kernel ;)  Any ideas how I can patch
        up hook_entry / underflow appropriately?  Is this even the
        problem?

        Cheers,
        Bryan Cardillo
        Penn Bioinformatics Core
        University of Pennsylvania
        dillo@seas.upenn.edu
