From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: undefined reference to `nf_conntrack_untracked'
Date: Wed, 9 Dec 2015 22:10:45 +0100
Message-ID: <20151209211045.GA2409@salvia>
References: <201512061207.vyKl9Dek%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201512061207.vyKl9Dek%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Dec 06, 2015 at 12:47:10PM +0800, kbuild test robot wrote:
> Hi Pablo,
> 
> FYI, the error/warning still remains.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   a2dbb7b56f2c29fc78b18a3fbe47ad80f6912092
> commit: bbde9fc1824aab58bc78c084163007dd6c03fe5b netfilter: factor out packet duplication for IPv4/IPv6
> date:   4 months ago
> config: x86_64-randconfig-s5-12061137 (attached as .config)
> reproduce:
>         git checkout bbde9fc1824aab58bc78c084163007dd6c03fe5b
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    net/built-in.o: In function `nf_dup_ipv4':
> >> (.text+0xd434f): undefined reference to `nf_conntrack_untracked'

I have just send this patch to address this problem:

http://patchwork.ozlabs.org/patch/554805/
