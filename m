From: Titus Winters <titus@cs.ucr.edu>
Subject: Add rule (ipt_entry?) from kernel space
Date: 28 May 2003 23:32:07 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054189927.1273.18.camel@branwen.winters-ca.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm working on a project that requires me to have a rule added by a
kernel module.  Well, I'm flexible on that requirement.  I need to add a
rule from both a setsockopt call and from a Match extension.  In any
case, I'm fairly stumped as to how I go about this.  My current
understanding of how the userspace iptables program works is that it
creates all the ipt_entries in one contiguous memory segment and then
the kernel side memcopies that for itself.  Is it best (or even safe) to
just add to the end of that glob (or kmalloc more space and copy that
glob over with more stuff at the end)?  Once added, is there any trick
to removal?

Any help would be appreciated, an example would be glorious.

Thanks,
-Titus Winters
