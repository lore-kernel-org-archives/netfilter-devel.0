From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: [rfc] ipt_owner.c improvements
Date: Fri, 04 Mar 2005 03:25:28 +0200
Message-ID: <4227B908.4070900@evtek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

I'd like to make few improvements to ipt_owner.c or perhaps to create 
something new that is like owner match.

First I'd like to improve performance for incoming packet matches. The 
next thing is to reliably identify sending/receiving process. Last 
proposal is to improve performance when matching is done several times 
per packet.


For incoming packets we can use code from sk callback mechanism:

         sk->sk_state_change     =       sock_def_wakeup;
         sk->sk_data_ready       =       sock_def_readable;

When userspace is informed following functions are called:

	sock_def_readable / sock_def_wakeup
	`-- wake_up_interruptible
	    `-- __wake_up
	       `-- __wake_up_common
	           |--...

Basically what happens is:

	list_for_each_safe(tmp, next, &sk->sk_sleep->task_list) {
		curr = list_entry(tmp, wait_queue_t, task_list);
		struct task_struct *owner = curr->task;
	        ...
	}

This relies on fact that to receive a packet task must sit on 
sk->sk_sleep queue (or in struct fasync_struct *fa).

However, packet can pass through netfilter just before task enters into 
sk_sleep resulting that the task might get the packet.

Just to remind: quote from iptables(8) man page "some packets (such as 
ICMP ping responses) may have no owner, and hence never match".

Also, some in-kernel stuff uses different functions to inform userspace:

	net/sunrpc/svcsock.c
	net/sunrpc/xprt.c
	net/bluetooth/rfcomm/core.c
	net/bluetooth/rfcomm/sock.c
	net/atm/common.c
	and possibly samba too

I haven't yet tested the behavior when using e.g. rpc. It might or might 
not work.


Next, slightly modified fs/proc/base.c:proc_exe_link():

struct file *get_vm_executable(struct task_struct *p)
{
	struct vm_area_struct *vma;
	struct file *vm_file = NULL;
	struct mm_struct *mm = p->mm;
	if (!mm)
		return NULL;
	vma = mm->mmap;
	while (vma) {
		if ((vma->vm_flags & VM_EXECUTABLE) &&
		    vma->vm_file) {
			vm_file = vma->vm_file;
			break; /* found! */
		}
		vma = vma->vm_next;
	}
	return vm_file;
}

this means for example that stat(2) information is available

	vfs_getattr(vm_file->f_vfsmnt, vm_file->f_dentry, &stat);

thus it would mean that it is possible to

	# iptables -A foo -m owner --cmd-owner XXX -j ACCEPT

where XXX can be something like '/usr/sbin/sshd' or device/inode number.


All tricks above should be performed only once per packet, so that doing

	# iptables -A foo -m owner --cmd-owner x -j ACCEPT
	# iptables -A foo -m owner --cmd-owner y -j ACCEPT
	# iptables -A foo -m owner --cmd-owner z -j ACCEPT
	# iptables -A foo -m owner --cmd-owner foo -j ACCEPT
	# iptables -A foo -m owner --cmd-owner bar -j ACCEPT
	# iptables -A foo -m owner --cmd-owner baz -j ACCEPT
         ...

would not waste system resources.

Targets are allowed to modify skb so that 'skb->sk->foo = bar' can be 
done. Would it make sense to have an OWNER target (that requires mangle 
table?)? If yes, what would be the behavior if the OWNER target is not 
yet passed:

	# iptables -A foo -m owner --cmd-owner x -j ACCEPT
	# iptables -A foo -j OWNER
	# iptables -A foo -m owner --cmd-owner y -j ACCEPT

Alternatively I can keep list of tasks and socket and put up a timer to 
clean the list once awhile.



Regards,
Juha Heljoranta
