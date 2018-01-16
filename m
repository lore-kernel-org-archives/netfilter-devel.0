From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v2] netfilter: delete /proc THIS_MODULE references
Date: Tue, 16 Jan 2018 09:45:39 +0100
Message-ID: <20180116084538.ichopjgjj7fx5xl6@verge.net.au>
References: <20180113170831.GA1016@avx2>
 <20180115214532.GD6942@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, ja@ssi.bg
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:37198 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAPIpm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 03:45:42 -0500
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
> 
> # ipvs
> Acked-by: Julian Anastasov <ja@ssi.bg>

Likewise, the IPVS portion looks good to me.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
