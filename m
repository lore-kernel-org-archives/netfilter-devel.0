From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: delete /proc THIS_MODULE references
Date: Fri, 19 Jan 2018 14:11:14 +0100
Message-ID: <20180119131114.nrvon4di4byi64i6@salvia>
References: <20180113170831.GA1016@avx2>
 <20180115214532.GD6942@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, ja@ssi.bg
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754873AbeASNLS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 08:11:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3902620A52A
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 14:11:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2448DDA858
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 14:11:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180115214532.GD6942@avx2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 16, 2018 at 12:45:32AM +0300, Alexey Dobriyan wrote:
> /proc has been ignoring struct file_operations::owner field for 10 years.
> Specifically, it started with commit 786d7e1612f0b0adb6046f19b906609e4fe8b1ba
> ("Fix rmmod/read/write races in /proc entries"). Notice the chunk where
> inode->i_fop is initialized with proxy struct file_operations for
> regular files:
> 
> 	-               if (de->proc_fops)
> 	-                       inode->i_fop = de->proc_fops;
> 	+               if (de->proc_fops) {
> 	+                       if (S_ISREG(inode->i_mode))
> 	+                               inode->i_fop = &proc_reg_file_ops;
> 	+                       else
> 	+                               inode->i_fop = de->proc_fops;
> 	+               }
> 
> VFS stopped pinning module at this point.

Applied, thanks.
