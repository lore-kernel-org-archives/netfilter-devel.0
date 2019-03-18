Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2BCC4360F
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 18:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A784D20989
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 18:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfCRSzC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 14:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19125 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfCRSzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 14:55:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 627D813A4D;
        Mon, 18 Mar 2019 18:55:01 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-22.phx2.redhat.com [10.3.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 084045D705;
        Mon, 18 Mar 2019 18:54:48 +0000 (UTC)
Date:   Mon, 18 Mar 2019 14:54:46 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V5 03/10] audit: read container ID of a process
Message-ID: <20190318185446.s2gqxmtnxxxkdeis@madcap2.tricolour.ca>
References: <cover.1552665316.git.rgb@redhat.com>
 <25543e3db4d8f3853119f92c09a60664555249a2.1552665316.git.rgb@redhat.com>
 <20190318111003.GA7364@hmswarspite.think-freely.org>
 <20190318181721.6e5jxqwvmifduzvq@madcap2.tricolour.ca>
 <20190318184856.GA4111@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318184856.GA4111@hmswarspite.think-freely.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 18 Mar 2019 18:55:01 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-03-18 14:48, Neil Horman wrote:
> On Mon, Mar 18, 2019 at 02:17:21PM -0400, Richard Guy Briggs wrote:
> > On 2019-03-18 07:10, Neil Horman wrote:
> > > On Fri, Mar 15, 2019 at 02:29:51PM -0400, Richard Guy Briggs wrote:
> > > > Add support for reading the audit container identifier from the proc
> > > > filesystem.
> > > > 
> > > > This is a read from the proc entry of the form
> > > > /proc/PID/audit_containerid where PID is the process ID of the task
> > > > whose audit container identifier is sought.
> > > > 
> > > > The read expects up to a u64 value (unset: 18446744073709551615).
> > > > 
> > > > This read requires CAP_AUDIT_CONTROL.
> > > > 
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > > ---
> > > >  fs/proc/base.c | 23 +++++++++++++++++++++--
> > > >  1 file changed, 21 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > > index 2505c46c8701..0b833cbdf5b6 100644
> > > > --- a/fs/proc/base.c
> > > > +++ b/fs/proc/base.c
> > > > @@ -1295,6 +1295,24 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
> > > >  	.llseek		= generic_file_llseek,
> > > >  };
> > > >  
> > > > +static ssize_t proc_contid_read(struct file *file, char __user *buf,
> > > > +				  size_t count, loff_t *ppos)
> > > > +{
> > > > +	struct inode *inode = file_inode(file);
> > > > +	struct task_struct *task = get_proc_task(inode);
> > > > +	ssize_t length;
> > > > +	char tmpbuf[TMPBUFLEN*2];
> > > > +
> > > Sorry, didn't notice this previously, but..
> > > Why *2 here?  Its not wrong per-se, but would it be better to just change
> > > TMPBUFLEN to be 22 bytes unilaterally?  Its only ever used on stack calls that
> > > arent that deep, and then you won't have to think about adjusting this call site
> > > if you ever change the value of TMPBUFLEN in the future.
> > 
> > TMPBUFLEN is 11 to accomodate a decimal representation of a u32 with
> > terminating NULL.  Since the contid is a u64, it was least disruptive
> > and made sense to me to just double it.  I could define a TMPBUFLEN2 to
> > be 21 if you prefer?
> > 
> I'm not adamant on any particular change, just noticing the inconsistency.  I
> usually write macro buffer sizes to accomodate the largest string I plan to
> hold, so it can be used ubiquitously when the overage is small and transiently
> allocated, but if you feel like the space would be better conserved a TMPBUFLEN/
> TMPBUFLEN2 approach would be fine (or a TMPBUFLENU32 / TMPBUFLENU64 macro set).

Ok, I see your point about it being transient.  I'll fix it up if there
is a respin.

> Its not anything that needs fixing now, just an observation for clean up at some
> future point.
> Neil
> 
> > > I'm fine with doing this in another patch later, but it seems like a worthwhile
> > > cleanup
> > > 
> > > functionality looks good beyond that nit.
> > > 
> > > > +	if (!task)
> > > > +		return -ESRCH;
> > > > +	/* if we don't have caps, reject */
> > > > +	if (!capable(CAP_AUDIT_CONTROL))
> > > > +		return -EPERM;
> > > > +	length = scnprintf(tmpbuf, TMPBUFLEN*2, "%llu", audit_get_contid(task));
> > > > +	put_task_struct(task);
> > > > +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> > > > +}
> > > > +
> > > >  static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> > > >  				   size_t count, loff_t *ppos)
> > > >  {
> > > > @@ -1325,6 +1343,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> > > >  }
> > > >  
> > > >  static const struct file_operations proc_contid_operations = {
> > > > +	.read		= proc_contid_read,
> > > >  	.write		= proc_contid_write,
> > > >  	.llseek		= generic_file_llseek,
> > > >  };
> > > > @@ -3039,7 +3058,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
> > > >  #ifdef CONFIG_AUDIT
> > > >  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
> > > >  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> > > > -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> > > > +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> > > >  #endif
> > > >  #ifdef CONFIG_FAULT_INJECTION
> > > >  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > > > @@ -3428,7 +3447,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
> > > >  #ifdef CONFIG_AUDIT
> > > >  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
> > > >  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> > > > -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> > > > +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> > > >  #endif
> > > >  #ifdef CONFIG_FAULT_INJECTION
> > > >  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > > > -- 
> > > > 1.8.3.1
> > > > 
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > 
> > - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
