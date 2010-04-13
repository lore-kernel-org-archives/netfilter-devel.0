From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] netfilter: xtables: inclusion of xt_condition
Date: Tue, 13 Apr 2010 13:38:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004131337180.16098@obet.zrqbmnf.qr>
References: <1270214599-22734-1-git-send-email-jengelh@medozas.de> <1270214599-22734-2-git-send-email-jengelh@medozas.de> <4BBB4134.2020007@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57058 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0DMLig (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:38:36 -0400
In-Reply-To: <4BBB4134.2020007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-06 16:12, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> +/* Defaults, these can be overridden on the module command-line. */
>> +static unsigned int condition_list_perms = S_IRUSR | S_IWUSR;
>> +static unsigned int condition_uid_perms;
>> +static unsigned int condition_gid_perms;
>
>I think it might be useful to make them overridable on a per-rule base
>if it doesn't cause inconsistent behaviour when sharing a condition
>variable.

That does not work; a condition variable can only be owned
by one uid.

>> +/* proc_lock is a user context only semaphore used for write access */
>> +/*           to the conditions' list.                               */
>> +static struct mutex proc_lock;
>DEFINE_MUTEX() ?
>> +	rcu_read_lock();
>> +	x = rcu_dereference(var->enabled);
>> +	rcu_read_unlock();
>That looks unnecessary. What exactly is that rcu lock trying to protect?
>Where is the corresponding rcu assignment?
>> +	if (mutex_lock_interruptible(&proc_lock) != 0)
>> +		return -EINTR;
>No need for interruptible locking, the section is very short and
>usually there's only a single iptables process running at a time.
>
>> +	var->status_proc->write_proc = condition_proc_write;
>> +	list_add_rcu(&var->list, &conditions_list);
>
>Why are you using the RCU variant? The list is only walked while
>holding the mutex, without using the _rcu list functions. Removal
>also happens while holding the mutex.

removed the rcu things.

>> +	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
>> +	if (proc_net_condition == NULL)
>> +		return -EACCES;
>> +
>> +	ret = xt_register_match(&condition_mt_reg);
>
>Matches are registered globally, not once per namespace.

fixed.
