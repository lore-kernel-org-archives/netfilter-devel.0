From: =?iso-8859-1?q?T=F6r=F6k_Edwin?= <edwin@gurde.com>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both incoming and outgoing packets
Date: Sat, 18 Feb 2006 14:32:14 +0200
Message-ID: <200602181432.14483.edwin@gurde.com>
References: <200602181410.59757.edwin.torok@level7.ro> <20060218122512.GG911@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, martinmaurer@gmx.at
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751198AbWBRMcs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20060218122512.GG911@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Saturday 18 February 2006 14:25, Christoph Hellwig wrote:
> > - I need to lock the task_list
> > 	- task_list lock export might be gone some day?
>
> yes.  in exactly half a year from now, and no new users are not allowed.
So I'll have to remove all code that relies on the task_list. Is 
proc_check_exe_fown() the only function that is affected by this?
>
> > 	- is locking tasklist when inside a softirq allowed?
>
> no.  for that reason we already removed a broken match from ipt_owner.
Is there an alternative for locking the tasklist, and iterating through all 
the threads to: find out the struct task*  given a struct fown_struct*. Or is 
there any other way to find out the inode, and mountpoint of that process?


Thanks,
Edwin
