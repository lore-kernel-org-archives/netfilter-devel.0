From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: NULL pointer dereference
Date: Thu, 23 Jul 2009 17:03:44 +0200
Message-ID: <4A687BD0.1030906@trash.net>
References: <4A6856E6.9030600@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070707070805030903070009"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41173 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbZGWPDt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:03:49 -0400
In-Reply-To: <4A6856E6.9030600@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070707070805030903070009
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Christoph A. wrote:
>> when executing the testscript [1] (just to see if my nftables setup is
>> working), I get the following stack trace.
>>
>> [1] http://article.gmane.org/gmane.linux.network/122512
>>
>> I'm using the latest version from:
>> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nft-2.6.git
>> kernel config is attached
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000014
>>  IP: [<f8b471ff>] nft_validate_data_load+0x20/0x53 [nf_tables]
> 
> Thanks for the report. This is likely happening because the kernel
> includes support for some changes for which I haven't pushed out the
> corresponding userspace support yet, but it certainly shouldn't oops.
> I'll look into it ...

I've added and pushed out this patch to fix it, thanks.


--------------070707070805030903070009
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 25e43454caa8cb21c9a8ebea2259a43cace18829
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jul 23 17:12:29 2009 +0200

    netfilter: nf_tables: fix oops in nft_validate_data_load()
    
    As reported by Christoph A. <casmls@gmail.com>, nftables will
    oops in nft_validate_data_load() when running the script from
    http://article.gmane.org/gmane.linux.network/122512
    
    BUG: unable to handle kernel NULL pointer dereference at 00000014
     IP: [<f8b471ff>] nft_validate_data_load+0x20/0x53 [nf_tables]
     *pde = 00000000
     Oops: 0000 [#1] SMP
     last sysfs file: /sys/class/net/lo/operstate
     Modules linked in: nft_log nft_counter nf_tables_ipv4 nf_tables ipv6 loop parport_pc parport psmouse battery ac serio_raw button i2c_piix4 pcspkr i2c_core evdev ext3 jbd mbcache ide_cd_mod cdrom ide_gd_mod ata_generic ata_piix libata scsi_mod ide_pci_generic floppy piix pcnet32 mii ide_core thermal fan thermal_sys
    
     Pid: 1916, comm: test-script Not tainted (2.6.30-rc1nft3 #1) VirtualBox
     EIP: 0060:[<f8b471ff>] EFLAGS: 00010246 CPU: 0
     EIP is at nft_validate_data_load+0x20/0x53 [nf_tables]
     EAX: f7016a00 EBX: 00000000 ECX: 00030000 EDX: 00000000
     ESI: f79c3b10 EDI: f6867e84 EBP: f79c3c74 ESP: f79c3ae4
      DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
     Process test-script (pid: 1916, ti=f79c2000 task=f790fb40 task.ti=f79c2000)
     Stack:
      00000000 f8b4a134 ffffff00 ffffff00 00000004 f79c3b10 f8b4d118 00000002
      f79c3b44 f8b494bf f790fcfc 00000000 f6ebcc78 f6ebcc80 00000000 00000000
      0000001c f6867e80 f79c3b94 f79c3c74 f79c3b28 00000000 f6867e40 00000002
     Call Trace:
      [<f8b4a134>] ? nft_immediate_init+0x5d/0x85 [nf_tables]
      [<f8b494bf>] ? nf_tables_newexpr+0x7e/0xa8 [nf_tables]
      [<f8b4985c>] ? nf_tables_newrule+0x373/0x447 [nf_tables]
    
    The reason is that nft_validate_data_load() unconditionally dereferences
    data->chain, while this is only valid for GOTO/JUMP verdicts.
    
    Fix by adding a check for the appropriate verdicts.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 64e5294..4d19a51 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2297,7 +2297,8 @@ int nft_validate_data_load(const struct nft_ctx *ctx, enum nft_registers reg,
 		if (data == NULL || type != NFT_DATA_VERDICT)
 			return -EINVAL;
 
-		if (ctx->chain->level + 1 > data->chain->level) {
+		if ((data->verdict == NFT_GOTO || data->verdict == NFT_JUMP) &&
+		    ctx->chain->level + 1 > data->chain->level) {
 			if (ctx->chain->level + 1 == NFT_JUMP_STACK_SIZE)
 				return -EMLINK;
 			data->chain->level = ctx->chain->level + 1;

--------------070707070805030903070009--
