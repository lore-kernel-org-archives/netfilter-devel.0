From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Patch net] ipt_CLUSTERIP: fix a race condition of proc file
 creation
Date: Thu, 8 Feb 2018 17:58:26 +0100
Message-ID: <20180208165826.ywawymn6aqhmtal2@salvia>
References: <20180208055918.20411-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, Xin Long <lucien.xin@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180208055918.20411-1-xiyou.wangcong@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Feb 07, 2018 at 09:59:17PM -0800, Cong Wang wrote:
> There is a race condition between clusterip_config_entry_put()
> and clusterip_config_init(), after we release the spinlock in
> clusterip_config_entry_put(), a new proc file with a same IP could
> be created immediately since it is already removed from the configs
> list, therefore it triggers this warning:
> 
> ------------[ cut here ]------------
> proc_dir_entry 'ipt_CLUSTERIP/172.20.0.170' already registered
> WARNING: CPU: 1 PID: 4152 at fs/proc/generic.c:330 proc_register+0x2a4/0x370 fs/proc/generic.c:329
> Kernel panic - not syncing: panic_on_warn set ...
> 
> As a quick fix, just move the proc_remove() inside the spinlock.

Applied, thanks.
