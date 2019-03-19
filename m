Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F10C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 22:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC80F217F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 22:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfCSWGz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 18:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbfCSWGz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 18:06:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 887FD89C33;
        Tue, 19 Mar 2019 22:06:53 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 240224D9F7;
        Tue, 19 Mar 2019 22:06:40 +0000 (UTC)
Date:   Tue, 19 Mar 2019 18:06:38 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     nhorman@tuxdriver.com, dhowells@redhat.com, ebiederm@xmission.com,
        simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
Subject: Re: [PATCH ghak90 V5 00/10] audit: implement container identifier
Message-ID: <20190319220638.4hc5jnelb6wwmsid@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1552665316.git.rgb@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 19 Mar 2019 22:06:54 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-03-15 14:29, Richard Guy Briggs wrote:
> Implement kernel audit container identifier.
> 
> This patchset is a fifth based on the proposal document (V3)
> posted:
> 	https://www.redhat.com/archives/linux-audit/2018-January/msg00014.html
> 
> The first patch was the last patch from ghak81 that was absorbed into
> this patchset since its primary justification is the rest of this
> patchset.
> 
> The second patch implements the proc fs write to set the audit container
> identifier of a process, emitting an AUDIT_CONTAINER_OP record to announce the
> registration of that audit container identifier on that process.  This patch
> requires userspace support for record acceptance and proper type
> display.
> 
> The third implements reading the audit container identifier from the proc
> filesystem for debugging.  This patch wasn't planned for upstream
> inclusion but is starting to become more likely.
> 
> The fourth implements the auxiliary record AUDIT_CONTAINER if an
> audit container identifier is associated with an event.  This patch
> requires userspace support for proper type display.
> 
> The 5th adds signal and ptrace support.
> 
> The 6th creates a local audit context to be able to bind a standalone
> record with a locally created auxiliary record.

Paul, we had discussed this briefly previously...  Adding an auxiliary
record to *any* audit event when CONFIG_AUDITSYSCALL is *not* enabled
will cause those records to be detached and not associated as one event.
Currently, CONFIG_AUDITSYSCALL is automatically enabled when
CONFIG_AUDIT is enabled on any architecture that supports
syscall auditing so the only time this is an issue is on an
architecture that does not support syscall auditing.  This is a known
bug/tradeoff in architectures that don't support syscall auditing with
audit container identifier records only at this point.

This affects the AUDIT_CONTAINER_ID record associated with
AUDIT_NETFILTER_PKT, AUDIT_*USER* records and any other records that are
issued regardless of the state of the audit syscall rules (AVCs, ANOM_*,
etc...)


I had this contid patchset ready to post a couple of weeks ago, but I
started investigating separating out the concept of an audit event from
the audit context due to the issue raised above.  The only thing
required to tie records together in an event is the mesage timestamp and
message serial number.  The rest of the context is unnecessary.

This should not be necessary if audit events and syscall context are
separated.  I've been working on a patchset which was experimental
looking to see if it would work.  It is working so that contid is no
longer dependant on audit syscall auditing, but the patches need a bit
of cleanup to be presentable.  This would solve the problem for
architectures that don't support syscall auditing.  This wasn't the
motivation for doing this work, but more the desire to separate the
concepts of audit events from audit context.  audit_log_start() doesn't
need audit context information, but only minimal audit event
information.  The very small hitch I've run into was how to define the
start of an event.  This is taken care of explicitly in AUDIT_*USER* and
AUDIT_NETFILTER_PKT events by a local context/event allocation.  It is
taken care of in the syscall case in the call to
__audit_syscall_entry(), but when auditing is not enabled for a task and
an unconditional record such as AUDIT_AVC is issued, we still want the
event information present.  The timestamp function call of
__audit_syscall_entry() could be moved to audit_syscall_entry() or
another lighter function such as audit_event_entry() in kernel/audit.c
to take care of only the event parameters and not context.

I acknowledge it was a risk to dive into it without explicit
conversations and work items to proceed with it.  I like the results,
but I'd be curious what your outlook are on this general idea and
approach.  Hard to say, I know, without seeing actual code, but I'll 
keep poking at it.  I like it because it finally makes a clear
distinction between events and syscalls, which hasn't been much of a
technical, and only a conceptual issue up until now.

> The 7th patch adds audit container identifier records to the user
> standalone records.
> 
> The 8th adds audit container identifier filtering to the exit,
> exclude and user lists.  This patch adds the AUDIT_CONTID field and
> requires auditctl userspace support for the --contid option.
> 
> The 9th adds network namespace audit container identifier labelling
> based on member tasks' audit container identifier labels.
> 
> The 10th adds audit container identifier support to standalone netfilter
> records that don't have a task context and lists each container to which
> that net namespace belongs.
> 
> Example: Set an audit container identifier of 123456 to the "sleep" task:
> 
>   sleep 2&  
>   child=$!
>   echo 123456 > /proc/$child/audit_containerid; echo $?
>   ausearch -ts recent -m container_op
>   echo child:$child contid:$( cat /proc/$child/audit_containerid)
> 
> This should produce a record such as:
> 
>   type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 old-contid=18446744073709551615 contid=123456 pid=628 auid=root uid=root tty=ttyS0 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 comm=bash exe=/usr/bin/bash res=yes 
> 
> 
> Example: Set a filter on an audit container identifier 123459 on /tmp/tmpcontainerid:
> 
>   contid=123459
>   key=tmpcontainerid
>   auditctl -a exit,always -F dir=/tmp -F perm=wa -F contid=$contid -F key=$key
>   perl -e "sleep 1; open(my \$tmpfile, '>', \"/tmp/$key\"); close(\$tmpfile);" &
>   child=$!
>   echo $contid > /proc/$child/audit_containerid
>   sleep 2
>   ausearch -i -ts recent -k $key
>   auditctl -d exit,always -F dir=/tmp -F perm=wa -F contid=$contid -F key=$key
>   rm -f /tmp/$key
> 
> This should produce an event such as:
> 
>   type=CONTAINER_ID msg=audit(2018-06-06 12:46:31.707:26953) : contid=123459 
>   type=PROCTITLE msg=audit(2018-06-06 12:46:31.707:26953) : proctitle=perl -e sleep 1; open(my $tmpfile, '>', "/tmp/tmpcontainerid"); close($tmpfile); 
>   type=PATH msg=audit(2018-06-06 12:46:31.707:26953) : item=1 name=/tmp/tmpcontainerid inode=25656 dev=00:26 mode=file,644 ouid=root ogid=root rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 
>   type=PATH msg=audit(2018-06-06 12:46:31.707:26953) : item=0 name=/tmp/ inode=8985 dev=00:26 mode=dir,sticky,777 ouid=root ogid=root rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=PARENT cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 
>   type=CWD msg=audit(2018-06-06 12:46:31.707:26953) : cwd=/root 
>   type=SYSCALL msg=audit(2018-06-06 12:46:31.707:26953) : arch=x86_64 syscall=openat success=yes exit=3 a0=0xffffffffffffff9c a1=0x5621f2b81900 a2=O_WRONLY|O_CREAT|O_TRUNC a3=0x1b6 items=2 ppid=628 pid=2232 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=perl exe=/usr/bin/perl subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=tmpcontainerid 
> 
> Example: Test multiple containers on one netns:
> 
>   sleep 5 &
>   child1=$!
>   containerid1=123451
>   echo $containerid1 > /proc/$child1/audit_containerid
>   sleep 5 &
>   child2=$!
>   containerid2=123452
>   echo $containerid2 > /proc/$child2/audit_containerid
>   iptables -I INPUT -i lo -p icmp --icmp-type echo-request -j AUDIT --type accept
>   iptables -I INPUT  -t mangle -i lo -p icmp --icmp-type echo-request -j MARK --set-mark 0x12345555
>   sleep 1;
>   bash -c "ping -q -c 1 127.0.0.1 >/dev/null 2>&1"
>   sleep 1;
>   ausearch -i -m NETFILTER_PKT -ts boot|grep mark=0x12345555
>   ausearch -i -m NETFILTER_PKT -ts boot|grep contid=|grep $containerid1|grep $containerid2
> 
> This should produce an event such as:
> 
>   type=NETFILTER_PKT msg=audit(03/15/2019 14:16:13.369:244) : mark=0x12345555 saddr=127.0.0.1 daddr=127.0.0.1 proto=icmp 
>   type=CONTAINER_ID msg=audit(03/15/2019 14:16:13.369:244) : contid=123452,123451
> 
> 
> Includes the last patch of https://github.com/linux-audit/audit-kernel/issues/81
> See the github issue for the kernel code https://github.com/linux-audit/audit-kernel/issues/90
> See: https://github.com/linux-audit/audit-userspace/issues/40
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> 
> Changelog:
> 
> v5
> - address loginuid and sessionid syscall scope in ghak104
> - address audit_context in CONFIG_AUDIT vs CONFIG_AUDITSYSCALL in ghak105
> - remove tty patch, addressed in ghak106
> - rebase on audit/next v5.0-rc1
>   w/ghak59/ghak104/ghak103/ghak100/ghak107/ghak105/ghak106/ghak105sup
> - update CONTAINER_ID to CONTAINER_OP in patch description
> - move audit_context in audit_task_info to CONFIG_AUDITSYSCALL
> - move audit_alloc() and audit_free() out of CONFIG_AUDITSYSCALL and into
>   CONFIG_AUDIT and create audit_{alloc,free}_syscall
> - use plain kmem_cache_alloc() rather than kmem_cache_zalloc() in audit_alloc()
> - fix audit_get_contid() declaration type error
> - move audit_set_contid() from auditsc.c to audit.c
> - audit_log_contid() returns void
> - audit_log_contid() handed contid rather than tsk
> - switch from AUDIT_CONTAINER to AUDIT_CONTAINER_ID for aux record
> - move audit_log_contid(tsk/contid) & audit_contid_set(tsk)/audit_contid_valid(contid)
> - switch from tsk to current
> - audit_alloc_local() calls audit_log_lost() on failure to allocate a context
> - add AUDIT_USER* non-syscall contid record
> - cosmetic cleanup double parens, goto out on err
> - ditch audit_get_ns_contid_list_lock(), fix aunet lock race
> - switch from all-cpu read spinlock to rcu, keep spinlock for write
> - update audit_alloc_local() to use ktime_get_coarse_real_ts64()
> - add nft_log support
> - add call from do_exit() in audit_free() to remove contid from netns
> - relegate AUDIT_CONTAINER ref= field (was op=) to debug patch
> 
> v4
> - preface set with ghak81:"collect audit task parameters"
> - add shallyn and sgrubb acks
> - rename feature bitmap macro
> - rename cid_valid() to audit_contid_valid()
> - rename AUDIT_CONTAINER_ID to AUDIT_CONTAINER_OP
> - delete audit_get_contid_list() from headers
> - move work into inner if, delete "found"
> - change netns contid list function names
> - move exports for audit_log_contid audit_alloc_local audit_free_context to non-syscall patch
> - list contids CSV
> - pass in gfp flags to audit_alloc_local() (fix audit_alloc_context callers)
> - use "local" in lieu of abusing in_syscall for auditsc_get_stamp()
> - read_lock(&tasklist_lock) around children and thread check
> - task_lock(tsk) should be taken before first check of tsk->audit
> - add spin lock to contid list in aunet
> - restrict /proc read to CAP_AUDIT_CONTROL
> - remove set again prohibition and inherited flag
> - delete contidion spelling fix from patchset, send to netdev/linux-wireless
> 
> v3
> - switched from containerid in task_struct to audit_task_info (depends on ghak81)
> - drop INVALID_CID in favour of only AUDIT_CID_UNSET
> - check for !audit_task_info, throw -ENOPROTOOPT on set
> - changed -EPERM to -EEXIST for parent check
> - return AUDIT_CID_UNSET if !audit_enabled
> - squash child/thread check patch into AUDIT_CONTAINER_ID patch
> - changed -EPERM to -EBUSY for child check
> - separate child and thread checks, use -EALREADY for latter
> - move addition of op= from ptrace/signal patch to AUDIT_CONTAINER patch
> - fix && to || bashism in ptrace/signal patch
> - uninline and export function for audit_free_context()
> - drop CONFIG_CHANGE, FEATURE_CHANGE, ANOM_ABEND, ANOM_SECCOMP patches
> - move audit_enabled check (xt_AUDIT)
> - switched from containerid list in struct net to net_generic's struct audit_net
> - move containerid list iteration into audit (xt_AUDIT)
> - create function to move namespace switch into audit
> - switched /proc/PID/ entry from containerid to audit_containerid
> - call kzalloc with GFP_ATOMIC on in_atomic() in audit_alloc_context()
> - call kzalloc with GFP_ATOMIC on in_atomic() in audit_log_container_info()
> - use xt_net(par) instead of sock_net(skb->sk) to get net
> - switched record and field names: initial CONTAINER_ID, aux CONTAINER, field CONTID
> - allow to set own contid
> - open code audit_set_containerid
> - add contid inherited flag
> - ccontainerid and pcontainerid eliminated due to inherited flag
> - change name of container list funcitons
> - rename containerid to contid
> - convert initial container record to syscall aux
> - fix spelling mistake of contidion in net/rfkill/core.c to avoid contid name collision
> 
> v2
> - add check for children and threads
> - add network namespace container identifier list
> - add NETFILTER_PKT audit container identifier logging
> - patch description and documentation clean-up and example
> - reap unused ppid
> 
> Richard Guy Briggs (10):
>   audit: collect audit task parameters
>   audit: add container id
>   audit: read container ID of a process
>   audit: log container info of syscalls
>   audit: add containerid support for ptrace and signals
>   audit: add support for non-syscall auxiliary records
>   audit: add containerid support for user records
>   audit: add containerid filtering
>   audit: add support for containerid to network namespaces
>   audit: NETFILTER_PKT: record each container ID associated with a netNS
> 
>  fs/proc/base.c             |  55 +++++++++
>  include/linux/audit.h      | 107 +++++++++++++---
>  include/linux/sched.h      |   7 +-
>  include/uapi/linux/audit.h |   8 +-
>  init/init_task.c           |   3 +-
>  init/main.c                |   2 +
>  kernel/audit.c             | 300 +++++++++++++++++++++++++++++++++++++++++++--
>  kernel/audit.h             |   9 ++
>  kernel/auditfilter.c       |  47 +++++++
>  kernel/auditsc.c           |  89 ++++++++++----
>  kernel/fork.c              |   1 -
>  kernel/nsproxy.c           |   4 +
>  net/netfilter/nft_log.c    |  11 +-
>  net/netfilter/xt_AUDIT.c   |  11 +-
>  14 files changed, 592 insertions(+), 62 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
