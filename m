From: Giacomo <delleceste@gmail.com>
Subject: help tasklist_lock
Date: Mon, 25 Sep 2006 10:10:38 +0200
Message-ID: <200609251010.38830.delleceste@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Good morning to all!
I've written a module which needs to lock the tasklist_lock to read
the processes and get their pid.

Before kernel source 2.6.18 the symbol tasklist_lock was exported inside the
file fork.c.
With kernel 2.6.18, such symbol is no more exported, albeit a large number of
other source files use it.

My code does not compile any more and it says unexported symbol during
the compilation.

How can i do it?
Is there a way to make my module see the tasklist_lock?

The documentation of the kernel says:

What:   remove EXPORT_SYMBOL(tasklist_lock)
When:   August 2006
Files:  kernel/fork.c
Why:    tasklist_lock protects the kernel internal task list.  Modules have
       no business looking at it, and all instances in drivers have been due
       to use of too-lowlevel APIs.  Having this symbol exported prevents
       moving to more scalable locking schemes for the task list.

while my code does simply the following:

struct task_struct *get_uid_from_pid(const pid_t uspace_pid)
{
       struct task_struct *task;
       /* task list must not change while we are reading!
        * We are not in atomic */
       read_lock(&tasklist_lock);
       for_each_process(task)
       {
               if (task->pid == uspace_pid)
                 {
                         read_unlock(&tasklist_lock);
                         return task;
                 }
       }
       read_unlock(&tasklist_lock);
       return NULL;
}

Thanks a lot for any suggestion.

Giacomo S.
-- 
Giacomo S.
http://www.giacomos.it
 
- - - - - - - - - - - - - - - - - - - - - -

Proteggi il tuo PC provando il mio semplice FIREWALL:
http://www.giacomos.it/ipfire

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
