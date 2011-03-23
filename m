From: aletum@lavabit.com
Subject: ipt_owner pid match can be fixed
Date: Wed, 23 Mar 2011 19:53:05 +0300
Message-ID: <20110323195305.8fb79fe1.aletum@lavabit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from karen.lavabit.com ([72.249.41.33]:32849 "EHLO karen.lavabit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1CWRYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:24:32 -0400
Received: from e.earth.lavabit.com (e.earth.lavabit.com [192.168.111.14])
	by karen.lavabit.com (Postfix) with ESMTP id 4F45511BCB0
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2011 11:53:05 -0500 (CDT)
Received: from wwwwww-701sd (109.235.184.178)
	by lavabit.com with ESMTP id A5WPDXOOVUX5
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2011 11:53:02 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I looked at the code of 2.6.13 kernel to see why owner match pid feature was dropped from kernel.
The stated reason was:
-------------------------
Changelog-2.6.14 :
   [NETFILTER]: Remove tasklist_lock abuse in ipt{,6}owner

   Rip out cmd/sid/pid matching since its unfixable broken and stands in
   the way of locking changes to tasklist_lock.
--------------------------

   I think there is a way to work around this tasklist_lock abuse.
   I have inserted my comments between lines of the kernel code.
   
	static int
  57match_pid(const struct sk_buff *skb, pid_t pid)
  58{
  59        struct task_struct *p;
  60        struct files_struct *files;
  61        int i;
  62
  63        read_lock(&tasklist_lock);
  64        p = find_task_by_pid(

//At this point we can release the lock by read_unlock(&tasklist_lock);
//unless of course the lock needs to be held to do task_lock later on
//I'm not sure about this one.
  
  65        if (!p)
  66                goto out;
  67        task_lock(

// even if tasklist_lock needed to be held in order to do task_
// we certainly can release both locks at this stage, can't we?
  
  68        files = p->files;
  69        if(files) {
  70                spin_lock(&files->file_lock);
  71                for (i=0; i < files->max_fds; i++) {
  72                        if (fcheck_files(files, i) ==
  73                            skb->sk->sk_socket->file) {
  74                                spin_unlock(&files->file_lock);
  75                                task_unlock(p);
  76                                read_unlock(&tasklist_lock);
  77                                return 1;
  78                        }
  79                }
  80                spin_unlock(&files->file_lock);
  81        }
  82        task_unlock(p);
  83out:
  84        read_unlock(&tasklist_lock);
  85        return 0;
  86}

This will certainly reduce tasklist lock time by a factor of 10.
Please let me know if my findings are valid and if they are, would it be possible to return pid match option back to netfilter


-- 
 <aletum@lavabit.com>

