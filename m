From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
Date: Wed, 15 Aug 2007 21:20:43 -0700
Message-ID: <46C3D09B.6060405@intel.com>
References: <20070815235825.GB17004@redhat.com>	 <1187224811.5906.55.camel@localhost>  <46C3B428.4000003@intel.com> <1187234225.5906.73.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756776AbXHPEVX@vger.kernel.org>
In-Reply-To: <1187234225.5906.73.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Joe Perches wrote:
> On Wed, 2007-08-15 at 19:19 -0700, Kok, Auke wrote:
>> Joe Perches wrote:
>>> On Wed, 2007-08-15 at 19:58 -0400, Dave Jones wrote:
>>> There's more than a few of these (not inspected).
>>> $ egrep -r --include=*.c "\bif[[:space:]]*\([^\)]*\)[[:space:]]*\;" * 
>>> arch/sh/boards/se/7343/io.c:    if (0) ;
>>> drivers/atm/iphase.c:     if (!desc1) ;
>>> drivers/infiniband/hw/mlx4/mad.c:       if (!err);
>>> drivers/isdn/capi/capiutil.c:   else if (c <= 0x0f);
>>> drivers/net/tokenring/ibmtr.c:  else if (ti->shared_ram_paging == 0xf);  /* No paging in adapter */
>>> drivers/s390/scsi/zfcp_erp.c:           if (status == ZFCP_ERP_SUCCEEDED) ;     /* no further action */
>>> fs/hostfs/hostfs_user.c:        if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
>>> net/netfilter/xt_u32.c:         if (skb->len < 4 || pos > skb->len - 4);
>>> sound/pci/au88x0/au88x0_synth.c:                                if (eax == 0) ;
>> sounds like an excellent candidate check for checkpatch.pl !!!
> 
> I think it's poor style and all of these should go away.
> 
> the netfilter one appears to be a real error too.

I was more thinking of making sure that none of these slip back in...

Auke
