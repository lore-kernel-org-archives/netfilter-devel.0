From: "Volodymyr G.L." <voll@te.net.ua>
Subject: Minor error/typo in nf_reinject. And a couple of questions.
Date: Fri, 17 Feb 2006 19:08:06 +0200
Message-ID: <43F602F6.9050502@te.net.ua>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi, All.

Here is a little snippet of code from function nf_reinject (lines 207-220 in
net/netfilter/nf_queue.c in Linus' kernel tree):

------- code begins -------
/* Drop reference to owner of hook which queued us. */
module_put(info->elem->owner);

list_for_each_rcu(i, &nf_hooks[info->pf][info->hook]) {
         if (i == elem)
         break;
}

if (elem == &nf_hooks[info->pf][info->hook]) {
         /* The module which sent it to userspace is gone. */
         NFDEBUG("%s: module disappeared, dropping packet.\n",
                 __FUNCTION__);
         verdict = NF_DROP;
}
------- code ends -------

I guess it is a little error/typo in the last if-statement. Apparently it was
meant to check whether end of the linked list was reached in previous
list_for_each_rcu macro, i.e. elem wasn't found on the list. But then variable
"i" not "elem" must be compared to address of the appropriate list head.

Besides I don't see why elem can be dereferenced before module_put and can't be
dereferenced after it, and therefore packet must be dropped. Yes, after
module_put (if sum of all per-cpu reference counters equals zero) unloading of
the module in question may be initiated. But in the cleanup_module function it
will invoke nf_unregister_hook which in turn will call synchronize_net which
will call synchronize_kernel, so rmmod process will be put to sleep until all
currently executing RCU read sides have completed. And almost whole nf_reinject
function is one RCU read-side critical section. So why even bother with
checking? If data referenced by elem was consistent before module_put it must be
consistent after module_put. Of course all this imho and correct only if module
can call nf_unregister_hook only from cleanup_module function.

But if modules can call nf_{un,}register_hook functions not only from
init_module and cleanup_module, provided that nf_hook_ops structure can be
freed/allocated dynamically, then a couple of other questions arise to the
entire scheme of saving (in function nf_queue) pointer to the module's
nf_hook_ops structure as elem member of nf_info structure for later use in
nf_reinject function.

I would be very appreciate if anyone can clarify this issues to me.

P.S. Sorry for my bad English.
