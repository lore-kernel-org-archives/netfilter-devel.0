From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: Use is_zero_ether_addr instead of
 static and memcmp
Date: Fri, 30 Mar 2018 11:54:06 +0200
Message-ID: <20180330095406.chw56e7rizhmcfuo@salvia>
References: <687a4edaed07441681d3bfe3b63aa4feb55b9d61.1521567319.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <687a4edaed07441681d3bfe3b63aa4feb55b9d61.1521567319.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 20, 2018 at 10:35:47AM -0700, Joe Perches wrote:
> To make the test a bit clearer and to reduce object size a little.
> 
> Miscellanea:
> 
> o remove now unnecessary static const array
> 
> $ size ip_set_hash_mac.o*
>    text	   data	    bss	    dec	    hex	filename
>   22822	   4619	     64	  27505	   6b71	ip_set_hash_mac.o.allyesconfig.new
>   22932	   4683	     64	  27679	   6c1f	ip_set_hash_mac.o.allyesconfig.old
>   10443	   1040	      0	  11483	   2cdb	ip_set_hash_mac.o.defconfig.new
>   10507	   1040	      0	  11547	   2d1b	ip_set_hash_mac.o.defconfig.old

Applied, thanks Joe.
