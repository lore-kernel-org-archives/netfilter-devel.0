From: Giacomo <delleceste@gmail.com>
Subject: module cleanup and timeouts
Date: Mon, 11 Dec 2006 10:11:56 +0100
Message-ID: <885896af0612110111v69660248vb65d78358aae5d11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter devel" <netfilter-devel@lists.netfilter.org>
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

Good morning to all.
In my kernel code which implements a network filter, the data structures
containing the rules have a timeout after which they are destroyed and
removed from the list.
The destruction and removal take place in a callback specified at the
structure creation time (handle_keep_state_timeout)

void fill_timer_table_fields(struct state_table *state_t)
{
	long int expi;
	expi = get_timeout_by_state(state_t->protocol, state_t->state.state);
	init_timer(&state_t->timer_statelist);
	state_t->timer_statelist.expires = jiffies + expi * HZ;
	state_t->timer_statelist.data = (unsigned long) state_t;
        /* handle_keep_state_timeout is the function called at expire time */
	state_t->timer_statelist.function = handle_keep_state_timeout;
}

handle_keep_state_timeout() does the following:
- deletes the timer
- deletes the table from the list
- schedules the memory kfree by call_rcu()

/* This routine acquires the write lock before deleting an item
 * on the list of the state connections.
 */
void handle_keep_state_timeout(unsigned long data)
{
    struct state_table *st_to_free = NULL;
    spin_lock_bh(&state_list_lock);
    st_to_free = (struct state_table *) data;
	del_timer(&st_to_free->timer_statelist);
	list_del_rcu(&st_to_free->list);
	call_rcu(&st_to_free->state_rcuh, free_state_entry_rcu_call);
	spin_unlock_bh(&state_list_lock);
}

This works but, when i remove the module from the kernel,
THERE IS A CRASH if one entry timeouts at the same time
in which the module is removed.

The call trace ends with the following:

__rcu_process_callbacks
rcu_process_callback
tasklet_action
do_softirq

The exit function invoked at the module removal is the following:

int free_state_tables(void)
{
	struct list_head *pos;
	struct list_head *q;
	struct state_table *tl;
	int counter = 0;
	/* free all entries in tables */
	spin_lock_bh(&state_list_lock);

	list_for_each_safe_rcu(pos, q, &root_state_table.list)
	{
		tl = list_entry(pos, struct state_table, list);
		del_timer(&tl->timer_statelist);
		list_del_rcu(&tl->list);
		tl->timer_statelist.data = (unsigned long) 0;
		tl->timer_statelist.function = NULL;
		kfree(tl);
		counter++;
	}
	spin_unlock_bh(&state_list_lock);
	return counter;
}

As one can see, spin_lock protects the list traversal in the exit function
synchronizing with the timeout callback above, but this is not enough.

I think that this is what happens:

1.We are in the exit list_for_each loop;
2.A table which is not already freed goes in timeout but
   the spin_lock in the callback prevents it to be freed;
3. we complete the exit function
4. the table expired in 2. enters the callback!!

Practically, it would be  necessary to disable the callbacks from
being executed (remove from the queue if there is a queue where
the callbacks wait to bve executed..) when we are in the exit function.

Any idea on how to prevent this behaviour?
Also if one has to be quite unlucky to remove the module exactly
at the same time in which a table expires.. it happens..

Thank you very much for any hint.


-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

IPFIREwall (http://www.giacomos.it/ipfire) viene presentato
all'Universita` degli Studi di Udine, il 28 ottobre, in occasione del
Linux Day 2006:
http://iglu.cc.uniud.it/linuxday

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
