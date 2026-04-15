Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0884A368264
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 11:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776251640; cv=none; b=WEynzSNBy2rvuCeJxoY8lySL46cizIDk174AAsIl3kqs3xj/60sS5dfBHkCAuiWXuLxD+5zfy5Tf4OwqX1ifZmVhPwQeTjjDBLynAxAxdHjyCN4wOFLUiuCNmeLvsgWfxlh1X1LaD8AJZQF2hyBV7NNeftv5hFJqkzEPS+s1H/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776251640; c=relaxed/simple;
	bh=8AIAr3pqdWaD86it8Y6986lhc/rfrpNCoIF4sfYhUkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEXgYYbx/SN2oQxbZqvjl6R2YP2D2/20T7mWFLweNTqR4bQ5aaubIXD8EcQg0YPcE+S+zEMLziJfy2fMisO8v3QNsFDMJi0KJAR+MelyvFbbzV9JhlHFq+wYDcOp4LyiYHcc9lLoyFGPa403rzZ7jgoB7Y4onwGKnUkT12lgvkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vrs/oTy2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vrs/oTy2"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BC2E760278;
	Wed, 15 Apr 2026 13:13:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776251636;
	bh=qqB3NMnGpTHS3IJmg/vVj+0easdMTY5LT32EZy4rqEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vrs/oTy2aWPVNVdHuisXGYVzpns2CK8e40ZviZ/r2Zsu0+oDbItvNTs11wu6IX5Pt
	 5TjADFM6qfuJ4lisRqobmhthRKvET9esIiCt8vaUH/UV1Joys/sZqNhZWB47gRt8bM
	 Pp2BGtAkfRYjx98pnkR4iCZLHhdlUMQKs7tZufPZBJ4W+RwDpEHsgMO9RCxjEO8Fa5
	 h/3azKN41K2qf411sBVsuVHVr4Ze+ThO/e3GgxkhaRr3MLfD28W8Y5lid3FNvIcQ1a
	 koGsStmQM6imUYAo+QvaYe75APTzq7aDwB+vAh6KqhuqZEcNchyV2vpmJ87m/6GxAp
	 NOB3YQcTSLjCg==
Date: Wed, 15 Apr 2026 13:13:53 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhe Zhao <zhe.alex.zhao@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH]netfilter module-autoload: duplicate request for
 netfilter module
Message-ID: <ad9y8Sdo-qk8WloW@chamomile>
References: <CABZCAAda40qju18nMGFqJhDvWvgV4RhNViQeyPyNpSYLUDnOfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABZCAAda40qju18nMGFqJhDvWvgV4RhNViQeyPyNpSYLUDnOfQ@mail.gmail.com>

On Tue, Apr 14, 2026 at 08:29:51PM +0800, Zhe Zhao wrote:
> Hi, Pablo
> 
> When boot up linux computer with netfilter I found there is below kernel
> messages

Maybe this patch helps you?

https://lore.kernel.org/netfilter-devel/20260415111236.57925-1-pablo@netfilter.org/T/#u

> kernel: ------------[ cut here ]------------
> kernel: module-autoload: duplicate request for module net-pf-16-proto-12
> kernel: WARNING: kernel/module/dups.c:184 at
> kmod_dup_request_exists_wait+0x18a/0x320, CPU#4: firewalld/1071
> kernel: Modules linked in: snd_hda_codec_intelhdmi snd_hda_codec_hdmi
> intel_rapl_msr intel_rapl_common snd_hda_codec_alc662 binfmt_misc
> snd_hda_codec_realtek_lib intel_uncore_frequency ommon
> snd_hda_codec_generic snd_hda_intel vfat sn>
> kernel: platform_profile snd igb intel_uncore i2c_i801 dca soundcore
> i2c_smbus mei_me mei idma64 intel_pch_thermal intel_pmc_core pmt_telemetry
> pmt_discovery pmt_class acpi_tad acpi_pad y intel_vsec loop zram xfs i915
> i2c_algo_bit dr>
> kernel: CPU: 4 UID: 0 PID: 1071 Comm: firewalld Tainted: G W 7.0.0 #4
> PREEMPT(lazy)
> kernel: Tainted: [W]=WARN
> kernel: Hardware name: HP HP ZHAN 99 Pro G1 MT/843C, BIOS F.48 07/27/2022
> kernel: RIP: 0010:kmod_dup_request_exists_wait+0x18d/0x320
> kernel: Code: c7 c7 00 0b 1c 8e e8 32 10 ce 00 48 89 df e8 ba ec 26 00 80
> 3d 13 e3 dc 01 00 0f 84 17 12 e2 ff 48 8d 3d 06 2f f7 01 48 89 ee <67> 48
> 0f b9 3a 45 84 e4 75 6b 41 c7 45 00 00 00 00 00 b8 01
> kernel: RSP: 0018:ffffb254449d3ce0 EFLAGS: 00010202
> kernel: RAX: 0000000000000000 RBX: ffffa24ae080e300 RCX: 0000000000000000
> kernel: RDX: 0000000000000000 RSI: ffffb254449d3d48 RDI: ffffffff8e365720
> kernel: RBP: ffffb254449d3d48 R08: 0000000000000000 R09: 0000000000000000
> kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
> kernel: R13: ffffb254449d3d2c R14: ffffa2483b0f8b00 R15: ffffa248c4830000
> kernel: FS: 00007f633ca875c0(0000) GS:ffffa24b92b3e000(0000)
> knlGS:0000000000000000
> kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 00007f463be5fc00 CR3: 00000001de71e003 CR4: 00000000003726f0
> kernel: Call Trace:
> kernel: <TASK>
> kernel: __request_module+0x189/0x400
> kernel: netlink_create+0xaf/0x240
> kernel: ? alloc_inode+0x38/0x150
> kernel: __sock_create+0x126/0x1d0
> kernel: __sys_socket+0x92/0x110
> kernel: __x64_sys_socket+0x13/0x20
> kernel: do_syscall_64+0x125/0x1200
> kernel: entry_SYSCALL_64_after_hwframe+0x6c/0x74
> kernel: RIP: 0033:0x7f633c3060db
> kernel: Code: 48 8b 55 f8 64 48 2b 14 25 28 00 00 00 75 02 c9 c3 e8 19 ae
> 00 00 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 8b 0d f5 fc 0e 00 f7 d8 64 89
> kernel: RSP: 002b:00007ffe0d24d668 EFLAGS: 00000202 ORIG_RAX:
> 0000000000000029
> kernel: RAX: ffffffffffffffda RBX: 00007f573be0df70 RCX: 00007f633c3060db
> kernel: RDX: 000000000000000c RSI: 0000000000000003 RDI: 0000000000000010
> kernel: RBP: 00007ffe0d24d680 R08: 00007f573be0df70 R09: 0000000000000001
> kernel: R10: 00007f573be0df60 R11: 0000000000000202 R12: 0000000000000000
> kernel: R13: 00007ffe0d24d858 R14: 000000000000000c R15: 0000000000000000
> kernel: </TASK>
> kernel: ---[ end trace 0000000000000000 ]---
> 
> It is always show up during Fedora system bootup, it seems thereis
> duplication module loading in the kernel for the netfilter module, I write
> a patch for this message fix
> below codes is based on new relesed Linux kernel 7.0, the above message can
> be seen in linux 6.5 and linux 7.0, It maybe a common issue.
> 
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 9a07c3215..a07497cb2 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -22,7 +22,7 @@ int __request_module(bool wait, const char *name, ...);
>  #define request_module(mod...) __request_module(true, mod)
>  #define request_module_nowait(mod...) __request_module(false, mod)
>  #define try_then_request_module(x, mod...) \
> - ((x) ?: (__request_module(true, mod), (x)))
> + ((x) ? (x) : (__request_module(true, mod), (x)))
>  #else
>  static inline int request_module(const char *name, ...) { return -ENOSYS; }
>  static inline int request_module_nowait(const char *name, ...) { return
> -ENOSYS; }
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 14f391b18..a71cf6172 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -588,6 +588,8 @@ struct module {
>  #endif
> 
>  #ifdef CONFIG_MODULES
> +/* not reentry load module */
> +bool kmod_dup_request_exists(const char *fmt, ...);
> 
>  /* Get/put a kernel symbol (calls must be symmetric) */
>  void *__symbol_get(const char *symbol);
> diff --git a/kernel/module/dups.c b/kernel/module/dups.c
> index 1d720a531..fcee60254 100644
> --- a/kernel/module/dups.c
> +++ b/kernel/module/dups.c
> @@ -116,6 +116,23 @@ static void kmod_dup_request_complete(struct
> work_struct *work)
>   queue_delayed_work(system_dfl_wq, &kmod_req->delete_work, 60 * HZ);
>  }
> 
> +bool kmod_dup_request_exists(const char *fmt, ...)
> +{
> +        bool existed = false;
> +        char module_name[MODULE_NAME_LEN];
> +        va_list args;
> +        va_start(args, fmt);
> +        vsnprintf(module_name, sizeof(module_name), fmt, args);
> +        va_end(args);
> +
> +        mutex_lock(&kmod_dup_mutex);
> +        existed = kmod_dup_request_lookup(module_name) != NULL;
> +        mutex_unlock(&kmod_dup_mutex);
> +
> +        return existed;
> +}
> +EXPORT_SYMBOL_GPL(kmod_dup_request_exists);
> +
>  bool kmod_dup_request_exists_wait(char *module_name, bool wait, int
> *dup_ret)
>  {
>   struct kmod_dup_req *kmod_req, *new_kmod_req;
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 4d609d5cf..9d57add89 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -664,7 +664,8 @@ static int netlink_create(struct net *net, struct
> socket *sock, int protocol,
>  #ifdef CONFIG_MODULES
>   if (!nl_table[protocol].registered) {
>   netlink_unlock_table();
> - request_module("net-pf-%d-proto-%d", PF_NETLINK, protocol);
> + try_then_request_module(kmod_dup_request_exists("net-pf-%d-proto-%d",
> PF_NETLINK, protocol),
> +                                                "net-pf-%d-proto-%d",
> PF_NETLINK, protocol);
>   netlink_lock_table();
>   }
>  #endif
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index a23d4c51c..8c2c8767a 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1446,8 +1446,9 @@ static int ctrl_getfamily(struct sk_buff *skb, struct
> genl_info *info)
>   if (res == NULL) {
>   genl_unlock();
>   up_read(&cb_lock);
> - request_module("net-pf-%d-proto-%d-family-%s",
> -       PF_NETLINK, NETLINK_GENERIC, name);
> +
> try_then_request_module(kmod_dup_request_exists("net-pf-%d-proto-%d-family-%s",
> +       PF_NETLINK, NETLINK_GENERIC, name), "net-pf-%d-proto-%d-family-%s",
> +                                       PF_NETLINK, NETLINK_GENERIC, name);
>   down_read(&cb_lock);
>   genl_lock();
>   res = genl_family_find_byname(name);
> 
> 
> the patch mainly detect there is already kmod under loading, and not
> request it again, can you check is this a know issues or not ?
> does this patch can fix this problems?
> 
> Thanks
> Br
> Alex
