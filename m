Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E213B20DE3
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 12:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776170206; cv=pass; b=pBLDsJku+dt6SlGCKOpFQgk0hebwdVUHMeUyyJYmkU8JEhdjY1xXNa9o1Ygxg8OyZBYCoPM0bntHq/G+7L9Rx12Rv5zK7UWy5XIa2WYkw4n0Or4IcND4Sxi7YUwJXmUIP9tk3xPCWmWy4Gjms0JBt0vR8pt3sMmYtPH9F6o/l0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776170206; c=relaxed/simple;
	bh=3QvKSMKEzGXKkNVsueagowDhcZXgcAoNooUo3a7+2W0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=K1a+KwSn3eDdXYI4Oh2BrCgxHuoQHt14zyUEeOVSExPJ0PweVhfvuHGQ7zv4AZ70uM0mQpMIAbz/jOkbClvVbPaO87pqVSGhk59yIINUX3LRSIPrkzQv+qaQP4UwwoIPoNmiXhW9U4ZeQ/cqd76+BUu5cBTgpgSeNn8cLVLMoko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmGQyTGy; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmGQyTGy"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dbff06e4a6so5292493a34.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 05:36:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776170204; cv=none;
        d=google.com; s=arc-20240605;
        b=E3STY+SYw3nSRyHr4GVP/YpSsTlCvGl/Fyfx35PHfSqMSP/fiVdl5nKivpx3v1vcEt
         XMz/A+QSkXYLxO8ke7Mzo6+B1hCZ8pV+oGdIn0IgCreTTSf1S0TJZqqlAeVD1mt0IYEk
         m9RSQt2dNAqDhBTdP6pOm+5ra2cYfOy2MG4R47F1qqXI7xdkgJukdWuJBOkXFU0jp5QD
         xyDubGFUdToIuFXPtuXa69lkf31Qbn5l9Mm4qbzQ6k8XOTF+eB2dsYUeWjBJTzEMFwQ8
         rsW+A8OxR0ujmz3V6xIFGwIp5tPzc0NP0Rpp2pBMZ7nE2bY16RqO/kcvFMKULz0n9gkF
         H9kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=fuAca5m0tTkIbgymk3EB2eOlCFH3RK0fRdrSHLmxZjo=;
        fh=cKWkouWS3FVHiDWvHNnshGDqRkV9Y7Uu5kJgmIjjs5c=;
        b=MQlajVXKqO/6qL1aSSnhyN3gSLO3Sp5BTTQiTB+2TSm0doWVpykyu06lgINUgJqxbB
         38f7oZiytt12GXOv/SZi1loHvSxkvnqMLruf+pHmc4rXVE9KdDXN2Q56rYZcTSpmdNGT
         hgnBVzBuv+qo1lgDlRvUDkEjh8Pz/h73hHlrNVmVy/xTbPRbmp++Fjn8qCKeaBuI0Oxn
         Wp851dnftUHJHyWzKCnAgUdsiqcrKi2ClY/3cZSGOoYVGiyrjH8BeibFEZUTLRY99krO
         t+Wpb+HoMt8u5WRUME/Xw3AMCw2Rqxaa0d9EFkYyjXnzkV6SYstKyjwg223mjlpDg0b+
         oPIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776170204; x=1776775004; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fuAca5m0tTkIbgymk3EB2eOlCFH3RK0fRdrSHLmxZjo=;
        b=jmGQyTGyEf/FFYtd85kXcnhZX8gFNaVRU14BIyVglygrkGN8PdGAHZiZRI/f7Mqdsc
         zTV5WgvL7lobIEoMymEldaN4MbM15GJ2i6r3dkf1Vfz4TVeGagcl9Bc75jYX/6F95Tit
         EZiYjhenk6l3I8MsSUGY84KJTZOX5hgQIBnO3CDAkJyNrl3eWsXQcESUVcS+JmIgCl4N
         Kt+vtvoagsqlM6T8PRM2r0yFZf1bY0A+oSleIefClUAdt7tZjzrP+aZjRUmR9hbKaZxK
         YQueR3cPwqw2eIUKbofePnM6UCPIROU+gjTCfEjTYPc4MmZ1RBPG/ZjQLu+FYHBcT/io
         HFWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776170204; x=1776775004;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuAca5m0tTkIbgymk3EB2eOlCFH3RK0fRdrSHLmxZjo=;
        b=BBHSXS6yy+Tcwpwcqgm7PdfZgTkuemMnRwmTjsUARFzeTDUhQAfrbjgj+TbJd4dR7m
         17D113j0O8PCQbMZWpESKAKfOPo65NqMi/wrxhgc29QcsWw20pKScHiplvciYJImUNZV
         PigLRFmmmjN7H0jfHYh1FUPXnL7ea3XbRoy4OEFDIgEKTGPpCGk1X9BgxhJk299zt/NZ
         fDXjZVowuDzm/p2iBBcLG12S4nRdOjbY5B7eYaKVBFpONR9/r2KkNWLq7HesCyLp7jMV
         dYOCbxWW9Xk5DIS0aje+DEKaghFbvyj2/w86QbFrOVhrqi7jrxPy4ZPsuUxMEgHGVlyQ
         p3rQ==
X-Gm-Message-State: AOJu0YwjVg6W4SfVCfWgMRSB7S2OK6s6eeDoZ98NOlHXJvZzk4TE1clR
	5VkwlzaF/KGxoUTvSaiLVJ9hDO6Qd6gYM0PnM66vWKv+xoXO1odk23DVbJthcP1cHVEjTdplxCl
	hdTz1YBZYqEOC+RgVzhYYCCvF+/YDoOkqdvCLhhY=
X-Gm-Gg: AeBDietPVQMYD17fOFNcCZYApHsgzGJF+rKzofeTAk5s0MQCoceSsyrXkHYvdMFXlRR
	3RG574euHLLuXQuUo4McD6wlUAZCS2J6BPXmpgC95PFTIlUyLf1EJpnPotru7G9TNldQ6Ey+5Ho
	5/BWNV5Ow+rYZBLD1VCzxShncBxG6KWmWNQXM1XnV7agaiRABYY5+64f4LKa4ea48ZmNKfuodv7
	VrHqRheKqcoYDdQD6nMopmoAP3mOy8qdZKXS4r2+USJc4RpDnqVJtUnCIREeiMHBf4tscEoezh9
	UnG0BEOo5Xl/HsRL7Q==
X-Received: by 2002:a05:6830:488e:b0:7d7:f584:f381 with SMTP id
 46e09a7af769-7dc27db6545mr10685805a34.14.1776170203821; Tue, 14 Apr 2026
 05:36:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Zhe Zhao <zhe.alex.zhao@gmail.com>
Date: Tue, 14 Apr 2026 20:36:32 +0800
X-Gm-Features: AQROBzB7lSYggQRzSaH8LgjTPJchVwWtgd8LktcnBA-R6qrrhCZZxxgxCZte-cY
Message-ID: <CABZCAAdBHShUBAX_SHyrvp2ukyWMZodtUG-OqyXeiv_c+LedFA@mail.gmail.com>
Subject: [PATCH]netfilter module-autoload: duplicate request for netfilter module
To: "pablo@netfilter.org" <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, Pablo

When boot up linux computer with netfilter there is below kernel
messages show up on my desktop

kernel: ------------[ cut here ]------------
kernel: module-autoload: duplicate request for module net-pf-16-proto-12
kernel: WARNING: kernel/module/dups.c:184 at
kmod_dup_request_exists_wait+0x18a/0x320, CPU#4: firewalld/1071
kernel: Modules linked in: snd_hda_codec_intelhdmi snd_hda_codec_hdmi
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662 binfmt_misc
snd_hda_codec_realtek_lib intel_uncore_frequency ommon
snd_hda_codec_generic snd_hda_intel vfat sn>
kernel: platform_profile snd igb intel_uncore i2c_i801 dca soundcore
i2c_smbus mei_me mei idma64 intel_pch_thermal intel_pmc_core
pmt_telemetry pmt_discovery pmt_class acpi_tad acpi_pad y intel_vsec
loop zram xfs i915 i2c_algo_bit dr>
kernel: CPU: 4 UID: 0 PID: 1071 Comm: firewalld Tainted: G W 7.0.0 #4
PREEMPT(lazy)
kernel: Tainted: [W]=WARN
kernel: Hardware name: HP HP ZHAN 99 Pro G1 MT/843C, BIOS F.48 07/27/2022
kernel: RIP: 0010:kmod_dup_request_exists_wait+0x18d/0x320
kernel: Code: c7 c7 00 0b 1c 8e e8 32 10 ce 00 48 89 df e8 ba ec 26 00
80 3d 13 e3 dc 01 00 0f 84 17 12 e2 ff 48 8d 3d 06 2f f7 01 48 89 ee
<67> 48 0f b9 3a 45 84 e4 75 6b 41 c7 45 00 00 00 00 00 b8 01
kernel: RSP: 0018:ffffb254449d3ce0 EFLAGS: 00010202
kernel: RAX: 0000000000000000 RBX: ffffa24ae080e300 RCX: 0000000000000000
kernel: RDX: 0000000000000000 RSI: ffffb254449d3d48 RDI: ffffffff8e365720
kernel: RBP: ffffb254449d3d48 R08: 0000000000000000 R09: 0000000000000000
kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
kernel: R13: ffffb254449d3d2c R14: ffffa2483b0f8b00 R15: ffffa248c4830000
kernel: FS: 00007f633ca875c0(0000) GS:ffffa24b92b3e000(0000)
knlGS:0000000000000000
kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007f463be5fc00 CR3: 00000001de71e003 CR4: 00000000003726f0
kernel: Call Trace:
kernel: <TASK>
kernel: __request_module+0x189/0x400
kernel: netlink_create+0xaf/0x240
kernel: ? alloc_inode+0x38/0x150
kernel: __sock_create+0x126/0x1d0
kernel: __sys_socket+0x92/0x110
kernel: __x64_sys_socket+0x13/0x20
kernel: do_syscall_64+0x125/0x1200
kernel: entry_SYSCALL_64_after_hwframe+0x6c/0x74
kernel: RIP: 0033:0x7f633c3060db
kernel: Code: 48 8b 55 f8 64 48 2b 14 25 28 00 00 00 75 02 c9 c3 e8 19
ae 00 00 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 29 00 00 00 0f 05
<48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f5 fc 0e 00 f7 d8 64 89
kernel: RSP: 002b:00007ffe0d24d668 EFLAGS: 00000202 ORIG_RAX: 0000000000000029
kernel: RAX: ffffffffffffffda RBX: 00007f573be0df70 RCX: 00007f633c3060db
kernel: RDX: 000000000000000c RSI: 0000000000000003 RDI: 0000000000000010
kernel: RBP: 00007ffe0d24d680 R08: 00007f573be0df70 R09: 0000000000000001
kernel: R10: 00007f573be0df60 R11: 0000000000000202 R12: 0000000000000000
kernel: R13: 00007ffe0d24d858 R14: 000000000000000c R15: 0000000000000000
kernel: </TASK>
kernel: ---[ end trace 0000000000000000 ]---

It is always show up during Fedora system bootup, it seems there is
duplication module loading in the kernel for the netfilter module, I
write a patch for this message fix
below patch codes is based on new relesed Linux kernel 7.0, the above
message can be seen in linux 6.5 and linux 7.0, It maybe a common
issue.

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 9a07c3215..a07497cb2 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -22,7 +22,7 @@ int __request_module(bool wait, const char *name, ...);
 #define request_module(mod...) __request_module(true, mod)
 #define request_module_nowait(mod...) __request_module(false, mod)
 #define try_then_request_module(x, mod...) \
- ((x) ?: (__request_module(true, mod), (x)))
+ ((x) ? (x) : (__request_module(true, mod), (x)))
 #else
 static inline int request_module(const char *name, ...) { return -ENOSYS; }
 static inline int request_module_nowait(const char *name, ...) {
return -ENOSYS; }
diff --git a/include/linux/module.h b/include/linux/module.h
index 14f391b18..a71cf6172 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -588,6 +588,8 @@ struct module {
 #endif

 #ifdef CONFIG_MODULES
+/* not reentry load module */
+bool kmod_dup_request_exists(const char *fmt, ...);

 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index 1d720a531..fcee60254 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -116,6 +116,23 @@ static void kmod_dup_request_complete(struct
work_struct *work)
  queue_delayed_work(system_dfl_wq, &kmod_req->delete_work, 60 * HZ);
 }

+bool kmod_dup_request_exists(const char *fmt, ...)
+{
+        bool existed = false;
+        char module_name[MODULE_NAME_LEN];
+        va_list args;
+        va_start(args, fmt);
+        vsnprintf(module_name, sizeof(module_name), fmt, args);
+        va_end(args);
+
+        mutex_lock(&kmod_dup_mutex);
+        existed = kmod_dup_request_lookup(module_name) != NULL;
+        mutex_unlock(&kmod_dup_mutex);
+
+        return existed;
+}
+EXPORT_SYMBOL_GPL(kmod_dup_request_exists);
+
 bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 {
  struct kmod_dup_req *kmod_req, *new_kmod_req;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4d609d5cf..9d57add89 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -664,7 +664,8 @@ static int netlink_create(struct net *net, struct
socket *sock, int protocol,
 #ifdef CONFIG_MODULES
  if (!nl_table[protocol].registered) {
  netlink_unlock_table();
- request_module("net-pf-%d-proto-%d", PF_NETLINK, protocol);
+ try_then_request_module(kmod_dup_request_exists("net-pf-%d-proto-%d",
PF_NETLINK, protocol),
+                                                "net-pf-%d-proto-%d",
PF_NETLINK, protocol);
  netlink_lock_table();
  }
 #endif
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index a23d4c51c..8c2c8767a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1446,8 +1446,9 @@ static int ctrl_getfamily(struct sk_buff *skb,
struct genl_info *info)
  if (res == NULL) {
  genl_unlock();
  up_read(&cb_lock);
- request_module("net-pf-%d-proto-%d-family-%s",
-       PF_NETLINK, NETLINK_GENERIC, name);
+ try_then_request_module(kmod_dup_request_exists("net-pf-%d-proto-%d-family-%s",
+       PF_NETLINK, NETLINK_GENERIC, name), "net-pf-%d-proto-%d-family-%s",
+                                       PF_NETLINK, NETLINK_GENERIC, name);
  down_read(&cb_lock);
  genl_lock();
  res = genl_family_find_byname(name);


The patch mainly check is there already netfilter kmod under loading,
if there is it will not load it again, can you check is this message a
known issue or not?  And this patch tested on my desktop, please check
is it reasonable to fix this issue.

Thanks
Br
Alex
