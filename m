Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD4CC10F09
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 10:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DC6920684
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 10:27:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=demfloro.ru header.i=@demfloro.ru header.b="nhHqoqOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfCHK1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:27:43 -0500
Received: from mx.demfloro.ru ([185.52.0.75]:60174 "EHLO mx.demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbfCHK1j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 05:27:39 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2019 05:27:34 EST
Received: from fire.localdomain (unknown [IPv6:2001:470:28:88::100])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: demfloro)
        by mx.demfloro.ru (Postfix) with ESMTPSA id 44G3NK38GHz9M4M;
        Fri,  8 Mar 2019 10:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru; s=052018;
        t=1552040274; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:in-reply-to:
         references; bh=+B09cGyye2K2ZReOPG1LmM8TgizGdUIc0LzrmL4tvUI=;
        b=nhHqoqOxxqKCQm+9suZVOMiNIejGSDONRSjq1+8NpvjwcGO0PJTc0CmhDK/dxA5JAyVRJl
        ceM+TCy+nLp4NB6NpHu26EHtMCYeUogd6G3C+TZX7p5RudgaiJubDT2Z86lV72B6GyLpXA
        GbqeZgGwi30bJVBR+dAA9oXPKwrH4KaAMstUiQt/rg9JGlfgm0erz5eBwqA3R3pImF5078
        LuldKTqr+/gdOfyeTUW68SQD7UoxHnc7FRT7HU7R6Iver7xR1EGMAQF082M1rhqOPJ4G09
        9ryparmfM0fqiMkpnPQQCfaIegkXacj/Obk+7Qcrhjnh9nVi25vib+87/WcBMA==
Date:   Fri, 8 Mar 2019 13:17:46 +0300
From:   Dmitrii Tcvetkov <demfloro@demfloro.ru>
To:     netfilter-devel@vger.kernel.org
Cc:     coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: NULL pointer dereference in nft_set_elem_destroy()
Message-ID: <20190308131746.5899877a@fire.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/sdyjrug81+Sa3YFDakGoMTv"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=demfloro.ru;
        s=arc052018; t=1552040274;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:content-transfer-encoding:in-reply-to:
         references; bh=+B09cGyye2K2ZReOPG1LmM8TgizGdUIc0LzrmL4tvUI=;
        b=eA8zlor20hbjevuQ2TxP8LBFcnKXaa5yePIFso9UUiw0JE8c+GbVSIPE1kJdSb8XIQ0eof
        4iFlMvdr0ab8V/o4nR75OJTVIarPhri6ppbeJQjOcBGQIbpQV+ggp8RfnopQ506QIooUzg
        Ny/0EbSStdnvVmUO1UayP3bbAhx+6CsahT8bu76UDjBsyFN1dKtYD1kCYkSyVD6gTiXKoQ
        CAKMefNEcP8iAC/lyvgN65WCIM2QGGXKa5bDKLDyD2NtcsW2NhHTVlYHNrjE3YfDQ9vzju
        GNy9eARIcXgKIU2kXm7IfGBi2E9xbnUpQ3lePIV/i2H6tq65Xh7hb4upqpiSZQ==
ARC-Seal: i=1; s=arc052018; d=demfloro.ru; t=1552040274; a=rsa-sha256;
        cv=none;
        b=Lwc2Wv36CJVzDNdRAe0uf26BK9ie5fI2Xnk8KNKkLkM3ijyhlRJ+kvTMCGDCNrNE5D7LGn
        P5fxSZlpWa8bXQ8T0Jw/jKBzRsnDwSx79wqpk3Uw0aq7tnltnin1RwsA1k3rwokllxqSsv
        TCgVG3dFzvkb1pXE9KPljrGt+6ESxLwAaqf9JzQ3mhHVnSB6taEBRCgsFlzWswZutVbo+z
        qYmXDVfWAxszPngrwH19Ci4jDjO9XN1SrdwK7Y/EPuZ1wP3WLP138O82E8TboJZ4s9JeFb
        1ZSRpIJRuPU34rdiXxlFJ37Gg3mbCqbMzSy9qQUbjhunoNwdPZI9R1h/xPnnug==
ARC-Authentication-Results: i=1;
        mx.demfloro.ru;
        auth=pass smtp.auth=demfloro smtp.mailfrom=demfloro@demfloro.ru
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--MP_/sdyjrug81+Sa3YFDakGoMTv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

After upgrade to 5.0 on XPS 13 9360 I get NULL pointer dereference in
dmesg (attached). Distro is Arch Linux, kernel is built with custom
config (attached), but distro kernel[1] reproduces the issue on the
laptop as well.

Bisect led me to commit f6ac858589768 (netfilter: nf_tables: unbind set
in rule from commit path), bisect log attached. The commit doesn't
revert cleanly on top of v5.0, and conflicts aren't trivial for me to
resolve.

The issue reproduces only on the laptop, probably it has something to
do with it's ruleset, it's attached too.

[1] https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux

--MP_/sdyjrug81+Sa3YFDakGoMTv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.txt

[Fri Mar  8 13:00:53 2019] Linux version 5.0.0-ARCH (feanor@fire) (gcc version 8.3.0 (GCC)) #2 SMP Fri Mar 8 12:29:02 MSK 2019
[Fri Mar  8 13:00:53 2019] Command line: BOOT_IMAGE=/boot/vmlinuz-linux-test root=/dev/mapper/xps-root rw cryptdevice=UUID=34167ea3-883e-42c4-9cd9-d19518301f18:system:allow-discards rootflags=noatime,autodefrag,ssd memtest=2 stack_guard_gap=512 pti=on spectre_v2=on spectre_v2_user=on spectre_v1=on spec_store_bypass_disable=on l1tf=full,force seed=V06tz0W5CYOdmdPrBXgtfPSOYCuF8WJ6d15yhEATUztOFED0uA page_poison=1 slub_debug=FZP hugepagesz=1G hugepages=3
[Fri Mar  8 13:00:53 2019] KERNEL supported cpus:
[Fri Mar  8 13:00:53 2019]   Intel GenuineIntel
[Fri Mar  8 13:00:53 2019] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[Fri Mar  8 13:00:53 2019] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[Fri Mar  8 13:00:53 2019] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[Fri Mar  8 13:00:53 2019] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
[Fri Mar  8 13:00:53 2019] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[Fri Mar  8 13:00:53 2019] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[Fri Mar  8 13:00:53 2019] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
[Fri Mar  8 13:00:53 2019] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
[Fri Mar  8 13:00:53 2019] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
[Fri Mar  8 13:00:53 2019] BIOS-provided physical RAM map:
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000000009e000-0x00000000000fffff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000000100000-0x000000005f2b8fff] usable
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000005f2b9000-0x000000005f2b9fff] ACPI NVS
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000005f2ba000-0x000000005f2bafff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000005f2bb000-0x0000000070874fff] usable
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000070875000-0x0000000070bfffff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000070c00000-0x0000000070c43fff] ACPI data
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000070c44000-0x000000007aef5fff] ACPI NVS
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000007aef6000-0x000000007b51ffff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000007b520000-0x000000007b5fefff] type 20
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000007b5ff000-0x000000007b5fffff] usable
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x000000007b600000-0x000000007f7fffff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[Fri Mar  8 13:00:53 2019] BIOS-e820: [mem 0x0000000100000000-0x000000027e7fffff] usable
[Fri Mar  8 13:00:53 2019] NX (Execute Disable) protection: active
[Fri Mar  8 13:00:53 2019] efi: EFI v2.40 by American Megatrends
[Fri Mar  8 13:00:53 2019] efi:  ACPI=0x70c0d000  ACPI 2.0=0x70c0d000  SMBIOS=0xf0000  SMBIOS 3.0=0xf0020  MEMATTR=0x6e22d018 
[Fri Mar  8 13:00:53 2019] SMBIOS 3.0.0 present.
[Fri Mar  8 13:00:53 2019] DMI: Dell Inc. XPS 13 9360/05HM5Y, BIOS 2.10.0 09/27/2018
[Fri Mar  8 13:00:53 2019] tsc: Detected 2700.000 MHz processor
[Fri Mar  8 13:00:53 2019] tsc: Detected 2712.000 MHz TSC
[Fri Mar  8 13:00:53 2019] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[Fri Mar  8 13:00:53 2019] e820: remove [mem 0x000a0000-0x000fffff] usable
[Fri Mar  8 13:00:53 2019] last_pfn = 0x27e800 max_arch_pfn = 0x400000000
[Fri Mar  8 13:00:53 2019] MTRR default type: write-back
[Fri Mar  8 13:00:53 2019] MTRR fixed ranges enabled:
[Fri Mar  8 13:00:53 2019]   00000-9FFFF write-back
[Fri Mar  8 13:00:53 2019]   A0000-BFFFF uncachable
[Fri Mar  8 13:00:53 2019]   C0000-FFFFF write-protect
[Fri Mar  8 13:00:53 2019] MTRR variable ranges enabled:
[Fri Mar  8 13:00:53 2019]   0 base 0080000000 mask 7F80000000 uncachable
[Fri Mar  8 13:00:53 2019]   1 base 007E000000 mask 7FFE000000 uncachable
[Fri Mar  8 13:00:53 2019]   2 base 007D000000 mask 7FFF000000 uncachable
[Fri Mar  8 13:00:53 2019]   3 disabled
[Fri Mar  8 13:00:53 2019]   4 disabled
[Fri Mar  8 13:00:53 2019]   5 disabled
[Fri Mar  8 13:00:53 2019]   6 disabled
[Fri Mar  8 13:00:53 2019]   7 disabled
[Fri Mar  8 13:00:53 2019]   8 disabled
[Fri Mar  8 13:00:53 2019]   9 disabled
[Fri Mar  8 13:00:53 2019] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
[Fri Mar  8 13:00:53 2019] last_pfn = 0x7b600 max_arch_pfn = 0x400000000
[Fri Mar  8 13:00:53 2019] check: Scanning 1 areas for low memory corruption
[Fri Mar  8 13:00:53 2019] Base memory trampoline at [(____ptrval____)] 98000 size 24576
[Fri Mar  8 13:00:53 2019] Using GB pages for direct mapping
[Fri Mar  8 13:00:53 2019] BRK [0x1f5401000, 0x1f5401fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5402000, 0x1f5402fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5403000, 0x1f5403fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5404000, 0x1f5404fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5405000, 0x1f5405fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5406000, 0x1f5406fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5407000, 0x1f5407fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5408000, 0x1f5408fff] PGTABLE
[Fri Mar  8 13:00:53 2019] BRK [0x1f5409000, 0x1f5409fff] PGTABLE
[Fri Mar  8 13:00:53 2019] early_memtest: # of tests: 2
[Fri Mar  8 13:00:53 2019]   0x0000000000010000 - 0x0000000000058000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x0000000000059000 - 0x000000000008c000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x000000000008c690 - 0x0000000000098000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x0000000000100000 - 0x000000003612d000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x000000003708e000 - 0x000000003f392000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x000000003f3d2000 - 0x000000005d491000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x000000005f382000 - 0x000000006e22d018 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x000000006e22d8f8 - 0x000000006fd4c000 pattern ffffffffffffffff
[Fri Mar  8 13:00:53 2019]   0x0000000100000000 - 0x00000001f3600000 pattern ffffffffffffffff
[Fri Mar  8 13:00:54 2019]   0x00000001f540d000 - 0x000000027e800000 pattern ffffffffffffffff
[Fri Mar  8 13:00:54 2019]   0x0000000000010000 - 0x0000000000058000 pattern 0000000000000000
[Fri Mar  8 13:00:54 2019]   0x0000000000059000 - 0x000000000008c000 pattern 0000000000000000
[Fri Mar  8 13:00:54 2019]   0x000000000008c690 - 0x0000000000098000 pattern 0000000000000000
[Fri Mar  8 13:00:54 2019]   0x0000000000100000 - 0x000000003612d000 pattern 0000000000000000
[Fri Mar  8 13:00:55 2019]   0x000000003708e000 - 0x000000003f392000 pattern 0000000000000000
[Fri Mar  8 13:00:55 2019]   0x000000003f3d2000 - 0x000000005d491000 pattern 0000000000000000
[Fri Mar  8 13:00:55 2019]   0x000000005f382000 - 0x000000006e22d018 pattern 0000000000000000
[Fri Mar  8 13:00:55 2019]   0x000000006e22d8f8 - 0x000000006fd4c000 pattern 0000000000000000
[Fri Mar  8 13:00:55 2019]   0x0000000100000000 - 0x00000001f3600000 pattern 0000000000000000
[Fri Mar  8 13:00:56 2019]   0x00000001f540d000 - 0x000000027e800000 pattern 0000000000000000
[Fri Mar  8 13:00:56 2019] Secure boot could not be determined
[Fri Mar  8 13:00:56 2019] RAMDISK: [mem 0x3612d000-0x3708dfff]
[Fri Mar  8 13:00:56 2019] ACPI: Early table checksum verification disabled
[Fri Mar  8 13:00:56 2019] ACPI: RSDP 0x0000000070C0D000 000024 (v02 DELL  )
[Fri Mar  8 13:00:56 2019] ACPI: XSDT 0x0000000070C0D0C0 0000FC (v01 DELL   CBX3     01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: FACP 0x0000000070C32B68 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: DSDT 0x0000000070C0D248 02591E (v02 DELL   CBX3     01072009 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: FACS 0x000000007AEF3180 000040
[Fri Mar  8 13:00:56 2019] ACPI: APIC 0x0000000070C32C78 000068 (v03 DELL   CBX3     01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: FPDT 0x0000000070C32CE0 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: FIDT 0x0000000070C32D28 0000AC (v01 DELL   CBX3     01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: MCFG 0x0000000070C32DD8 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
[Fri Mar  8 13:00:56 2019] ACPI: HPET 0x0000000070C32E18 000038 (v01 DELL   CBX3     01072009 AMI. 0005000B)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C32E50 000359 (v01 SataRe SataTabl 00001000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: BOOT 0x0000000070C331B0 000028 (v01 DELL   CBX3     01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C331D8 0012CF (v02 SaSsdt SaSsdt   00003000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: HPET 0x0000000070C344A8 000038 (v01 INTEL  KBL-ULT  00000001 MSFT 0000005F)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C344E0 000D84 (v02 INTEL  xh_rvp07 00000000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: UEFI 0x0000000070C35268 000042 (v01                 00000000      00000000)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C352B0 000EDE (v02 CpuRef CpuSsdt  00003000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: LPIT 0x0000000070C36190 000094 (v01 INTEL  KBL-ULT  00000000 MSFT 0000005F)
[Fri Mar  8 13:00:56 2019] ACPI: WSMT 0x0000000070C36228 000028 (v01 DELL   CBX3     00000000 MSFT 0000005F)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C36250 000161 (v02 INTEL  HdaDsp   00000000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C363B8 00029F (v02 INTEL  sensrhub 00000000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C36658 003002 (v02 INTEL  PtidDevc 00001000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C39660 0000DB (v02 INTEL  TbtTypeC 00000000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: DBGP 0x0000000070C39740 000034 (v01 INTEL           00000002 MSFT 0000005F)
[Fri Mar  8 13:00:56 2019] ACPI: DBG2 0x0000000070C39778 000054 (v00 INTEL           00000002 MSFT 0000005F)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C397D0 0007DD (v02 INTEL  UsbCTabl 00001000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: SSDT 0x0000000070C39FB0 0084F1 (v02 DptfTa DptfTabl 00001000 INTL 20160422)
[Fri Mar  8 13:00:56 2019] ACPI: NHLT 0x0000000070C424A8 00002D (v00 INTEL  EDK2     00000002      01000013)
[Fri Mar  8 13:00:56 2019] ACPI: BGRT 0x0000000070C424D8 000038 (v00                 01072009 AMI  00010013)
[Fri Mar  8 13:00:56 2019] ACPI: ASF! 0x0000000070C42510 0000A0 (v32 INTEL   HCG     00000001 TFSM 000F4240)
[Fri Mar  8 13:00:56 2019] ACPI: DMAR 0x0000000070C425B0 0000F0 (v01 INTEL  KBL      00000001 INTL 00000001)
[Fri Mar  8 13:00:56 2019] ACPI: Local APIC address 0xfee00000
[Fri Mar  8 13:00:56 2019] Zone ranges:
[Fri Mar  8 13:00:56 2019]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[Fri Mar  8 13:00:56 2019]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[Fri Mar  8 13:00:56 2019]   Normal   [mem 0x0000000100000000-0x000000027e7fffff]
[Fri Mar  8 13:00:56 2019] Movable zone start for each node
[Fri Mar  8 13:00:56 2019] Early memory node ranges
[Fri Mar  8 13:00:56 2019]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[Fri Mar  8 13:00:56 2019]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[Fri Mar  8 13:00:56 2019]   node   0: [mem 0x0000000000100000-0x000000005f2b8fff]
[Fri Mar  8 13:00:56 2019]   node   0: [mem 0x000000005f2bb000-0x0000000070874fff]
[Fri Mar  8 13:00:56 2019]   node   0: [mem 0x000000007b5ff000-0x000000007b5fffff]
[Fri Mar  8 13:00:56 2019]   node   0: [mem 0x0000000100000000-0x000000027e7fffff]
[Fri Mar  8 13:00:56 2019] Zeroed struct page in unavailable ranges: 63472 pages
[Fri Mar  8 13:00:56 2019] Initmem setup node 0 [mem 0x0000000000001000-0x000000027e7fffff]
[Fri Mar  8 13:00:56 2019] On node 0 totalpages: 2027536
[Fri Mar  8 13:00:56 2019]   DMA zone: 64 pages used for memmap
[Fri Mar  8 13:00:56 2019]   DMA zone: 22 pages reserved
[Fri Mar  8 13:00:56 2019]   DMA zone: 3996 pages, LIFO batch:0
[Fri Mar  8 13:00:56 2019]   DMA32 zone: 7138 pages used for memmap
[Fri Mar  8 13:00:56 2019]   DMA32 zone: 456820 pages, LIFO batch:63
[Fri Mar  8 13:00:56 2019]   Normal zone: 24480 pages used for memmap
[Fri Mar  8 13:00:56 2019]   Normal zone: 1566720 pages, LIFO batch:63
[Fri Mar  8 13:00:56 2019] Reserving Intel graphics memory at [mem 0x7d800000-0x7f7fffff]
[Fri Mar  8 13:00:56 2019] ACPI: PM-Timer IO Port: 0x1808
[Fri Mar  8 13:00:56 2019] ACPI: Local APIC address 0xfee00000
[Fri Mar  8 13:00:56 2019] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[Fri Mar  8 13:00:56 2019] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[Fri Mar  8 13:00:56 2019] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
[Fri Mar  8 13:00:56 2019] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[Fri Mar  8 13:00:56 2019] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[Fri Mar  8 13:00:56 2019] ACPI: IRQ0 used by override.
[Fri Mar  8 13:00:56 2019] ACPI: IRQ9 used by override.
[Fri Mar  8 13:00:56 2019] Using ACPI (MADT) for SMP configuration information
[Fri Mar  8 13:00:56 2019] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[Fri Mar  8 13:00:56 2019] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[Fri Mar  8 13:00:56 2019] [mem 0x7f800000-0xdfffffff] available for PCI devices
[Fri Mar  8 13:00:56 2019] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[Fri Mar  8 13:00:56 2019] random: get_random_bytes called from start_kernel+0x8a/0x45d with crng_init=0
[Fri Mar  8 13:00:56 2019] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[Fri Mar  8 13:00:56 2019] percpu: Embedded 42 pages/cpu @(____ptrval____) s131992 r8192 d31848 u1048576
[Fri Mar  8 13:00:56 2019] pcpu-alloc: s131992 r8192 d31848 u1048576 alloc=1*2097152
[Fri Mar  8 13:00:56 2019] pcpu-alloc: [0] 0 1 
[Fri Mar  8 13:00:56 2019] Built 1 zonelists, mobility grouping on.  Total pages: 1995832
[Fri Mar  8 13:00:56 2019] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux-test root=/dev/mapper/xps-root rw cryptdevice=UUID=34167ea3-883e-42c4-9cd9-d19518301f18:system:allow-discards rootflags=noatime,autodefrag,ssd memtest=2 stack_guard_gap=512 pti=on spectre_v2=on spectre_v2_user=on spectre_v1=on spec_store_bypass_disable=on l1tf=full,force seed=V06tz0W5CYOdmdPrBXgtfPSOYCuF8WJ6d15yhEATUztOFED0uA page_poison=1 slub_debug=FZP hugepagesz=1G hugepages=3
[Fri Mar  8 13:00:56 2019] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[Fri Mar  8 13:00:56 2019] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[Fri Mar  8 13:00:57 2019] Memory: 4664748K/8110144K available (14355K kernel code, 661K rwdata, 4104K rodata, 976K init, 1644K bss, 3445396K reserved, 0K cma-reserved)
[Fri Mar  8 13:00:57 2019] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[Fri Mar  8 13:00:57 2019] Kernel/User page tables isolation: enabled
[Fri Mar  8 13:00:57 2019] rcu: Hierarchical RCU implementation.
[Fri Mar  8 13:00:57 2019] rcu: 	RCU event tracing is enabled.
[Fri Mar  8 13:00:57 2019] rcu: 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
[Fri Mar  8 13:00:57 2019] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[Fri Mar  8 13:00:57 2019] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[Fri Mar  8 13:00:57 2019] NR_IRQS: 4352, nr_irqs: 512, preallocated irqs: 16
[Fri Mar  8 13:00:57 2019] spurious 8259A interrupt: IRQ7.
[Fri Mar  8 13:00:57 2019] Console: colour dummy device 80x25
[Fri Mar  8 13:00:57 2019] printk: console [tty0] enabled
[Fri Mar  8 13:00:57 2019] ACPI: Core revision 20181213
[Fri Mar  8 13:00:57 2019] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
[Fri Mar  8 13:00:57 2019] hpet clockevent registered
[Fri Mar  8 13:00:57 2019] APIC: Switch to symmetric I/O mode setup
[Fri Mar  8 13:00:57 2019] DMAR: Host address width 39
[Fri Mar  8 13:00:57 2019] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[Fri Mar  8 13:00:57 2019] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 19e2ff0505e
[Fri Mar  8 13:00:57 2019] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[Fri Mar  8 13:00:57 2019] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
[Fri Mar  8 13:00:57 2019] DMAR: RMRR base: 0x00000070957000 end: 0x00000070976fff
[Fri Mar  8 13:00:57 2019] DMAR: RMRR base: 0x0000007d000000 end: 0x0000007f7fffff
[Fri Mar  8 13:00:57 2019] DMAR: ANDD device: 1 name: \_SB.PCI0.I2C0
[Fri Mar  8 13:00:57 2019] DMAR: ANDD device: 2 name: \_SB.PCI0.I2C1
[Fri Mar  8 13:00:57 2019] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[Fri Mar  8 13:00:57 2019] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[Fri Mar  8 13:00:57 2019] DMAR-IR: Enabled IRQ remapping in xapic mode
[Fri Mar  8 13:00:57 2019] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[Fri Mar  8 13:00:57 2019] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x2717868ea45, max_idle_ns: 440795316085 ns
[Fri Mar  8 13:00:57 2019] Calibrating delay loop (skipped), value calculated using timer frequency.. 5424.00 BogoMIPS (lpj=27120000)
[Fri Mar  8 13:00:57 2019] pid_max: default: 32768 minimum: 301
[Fri Mar  8 13:00:57 2019] LSM: Security Framework initializing
[Fri Mar  8 13:00:57 2019] Yama: becoming mindful.
[Fri Mar  8 13:00:57 2019] AppArmor: AppArmor initialized
[Fri Mar  8 13:00:57 2019] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[Fri Mar  8 13:00:57 2019] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[Fri Mar  8 13:00:57 2019] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[Fri Mar  8 13:00:57 2019] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[Fri Mar  8 13:00:57 2019] mce: CPU supports 8 MCE banks
[Fri Mar  8 13:00:57 2019] mce: CPU0: Thermal monitoring enabled (TM1)
[Fri Mar  8 13:00:57 2019] process: using mwait in idle threads
[Fri Mar  8 13:00:57 2019] Last level iTLB entries: 4KB 128, 2MB 8, 4MB 8
[Fri Mar  8 13:00:57 2019] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[Fri Mar  8 13:00:57 2019] Spectre V2 : Mitigation: Full generic retpoline
[Fri Mar  8 13:00:57 2019] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[Fri Mar  8 13:00:57 2019] Spectre V2 : Enabling Restricted Speculation for firmware calls
[Fri Mar  8 13:00:57 2019] Spectre V2 : mitigation: Enabling always-on Indirect Branch Prediction Barrier
[Fri Mar  8 13:00:57 2019] Spectre V2 : User space: Mitigation: STIBP protection
[Fri Mar  8 13:00:57 2019] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled
[Fri Mar  8 13:00:57 2019] SMT: Force disabled
[Fri Mar  8 13:00:57 2019] Freeing SMP alternatives memory: 36K
[Fri Mar  8 13:00:57 2019] TSC deadline timer enabled
[Fri Mar  8 13:00:57 2019] smpboot: CPU0: Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz (family: 0x6, model: 0x8e, stepping: 0x9)
[Fri Mar  8 13:00:57 2019] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
[Fri Mar  8 13:00:57 2019] ... version:                4
[Fri Mar  8 13:00:57 2019] ... bit width:              48
[Fri Mar  8 13:00:57 2019] ... generic registers:      8
[Fri Mar  8 13:00:57 2019] ... value mask:             0000ffffffffffff
[Fri Mar  8 13:00:57 2019] ... max period:             00007fffffffffff
[Fri Mar  8 13:00:57 2019] ... fixed-purpose events:   3
[Fri Mar  8 13:00:57 2019] ... event mask:             00000007000000ff
[Fri Mar  8 13:00:57 2019] rcu: Hierarchical SRCU implementation.
[Fri Mar  8 13:00:57 2019] random: crng done (trusting CPU's manufacturer)
[Fri Mar  8 13:00:57 2019] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
[Fri Mar  8 13:00:57 2019] smp: Bringing up secondary CPUs ...
[Fri Mar  8 13:00:57 2019] x86: Booting SMP configuration:
[Fri Mar  8 13:00:57 2019] .... node  #0, CPUs:      #1
[Fri Mar  8 13:00:57 2019] smp: Brought up 1 node, 2 CPUs
[Fri Mar  8 13:00:57 2019] smpboot: Max logical packages: 1
[Fri Mar  8 13:00:57 2019] smpboot: Total of 2 processors activated (10848.00 BogoMIPS)
[Fri Mar  8 13:00:57 2019] devtmpfs: initialized
[Fri Mar  8 13:00:57 2019] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[Fri Mar  8 13:00:57 2019] futex hash table entries: 512 (order: 3, 32768 bytes)
[Fri Mar  8 13:00:57 2019] xor: automatically using best checksumming function   avx       
[Fri Mar  8 13:00:57 2019] pinctrl core: initialized pinctrl subsystem
[Fri Mar  8 13:00:57 2019] NET: Registered protocol family 16
[Fri Mar  8 13:00:57 2019] audit: initializing netlink subsys (disabled)
[Fri Mar  8 13:00:57 2019] audit: type=2000 audit(1552039258.060:1): state=initialized audit_enabled=0 res=1
[Fri Mar  8 13:00:57 2019] cpuidle: using governor menu
[Fri Mar  8 13:00:57 2019] Simple Boot Flag at 0x47 set to 0x80
[Fri Mar  8 13:00:57 2019] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[Fri Mar  8 13:00:57 2019] ACPI: bus type PCI registered
[Fri Mar  8 13:00:57 2019] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[Fri Mar  8 13:00:57 2019] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[Fri Mar  8 13:00:57 2019] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[Fri Mar  8 13:00:57 2019] PCI: Using configuration type 1 for base access
[Fri Mar  8 13:00:57 2019] HugeTLB registered 1.00 GiB page size, pre-allocated 3 pages
[Fri Mar  8 13:00:57 2019] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[Fri Mar  8 13:00:57 2019] cryptd: max_cpu_qlen set to 1000
[Fri Mar  8 13:00:57 2019] raid6: using algorithm avx2x4 gen() 0 MB/s
[Fri Mar  8 13:00:57 2019] raid6: .... xor() 0 MB/s, rmw enabled
[Fri Mar  8 13:00:57 2019] raid6: using avx2x2 recovery algorithm
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(Module Device)
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(Processor Device)
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(3.0 _SCP Extensions)
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(Processor Aggregator Device)
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(Linux-Dell-Video)
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[Fri Mar  8 13:00:57 2019] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[Fri Mar  8 13:00:57 2019] ACPI: 11 ACPI AML tables successfully acquired and loaded
[Fri Mar  8 13:00:57 2019] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[Fri Mar  8 13:00:57 2019] ACPI: Dynamic OEM Table Load:
[Fri Mar  8 13:00:57 2019] ACPI: SSDT 0xFFFF8CF2F492B0C8 0006B4 (v02 PmRef  Cpu0Ist  00003000 INTL 20160422)
[Fri Mar  8 13:00:57 2019] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[Fri Mar  8 13:00:57 2019] ACPI: Dynamic OEM Table Load:
[Fri Mar  8 13:00:57 2019] ACPI: SSDT 0xFFFF8CF2F4A614A8 0003FF (v02 PmRef  Cpu0Cst  00003001 INTL 20160422)
[Fri Mar  8 13:00:57 2019] ACPI: Dynamic OEM Table Load:
[Fri Mar  8 13:00:57 2019] ACPI: SSDT 0xFFFF8CF2F492F1C8 00065C (v02 PmRef  ApIst    00003000 INTL 20160422)
[Fri Mar  8 13:00:57 2019] ACPI: Dynamic OEM Table Load:
[Fri Mar  8 13:00:57 2019] ACPI: SSDT 0xFFFF8CF2F4A1EAA8 00018A (v02 PmRef  ApCst    00003000 INTL 20160422)
[Fri Mar  8 13:00:57 2019] ACPI: EC: EC started
[Fri Mar  8 13:00:57 2019] ACPI: EC: interrupt blocked
[Fri Mar  8 13:00:57 2019] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as first EC
[Fri Mar  8 13:00:57 2019] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x14, EC_CMD/EC_SC=0x934, EC_DATA=0x930
[Fri Mar  8 13:00:57 2019] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions
[Fri Mar  8 13:00:57 2019] ACPI: Interpreter enabled
[Fri Mar  8 13:00:57 2019] ACPI: (supports S0 S5)
[Fri Mar  8 13:00:57 2019] ACPI: Using IOAPIC for interrupt routing
[Fri Mar  8 13:00:57 2019] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[Fri Mar  8 13:00:57 2019] ACPI: Enabled 8 GPEs in block 00 to 7F
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: Power Resource [WRST] (on)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[Fri Mar  8 13:00:57 2019] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[Fri Mar  8 13:00:57 2019] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[Fri Mar  8 13:00:57 2019] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability LTR]
[Fri Mar  8 13:00:57 2019] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[Fri Mar  8 13:00:57 2019] PCI host bridge to bus 0000:00
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0x7f800000-0xdfffffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7fffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: root bus resource [bus 00-fe]
[Fri Mar  8 13:00:57 2019] pci 0000:00:00.0: [8086:5904] type 00 class 0x060000
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: [8086:5916] type 00 class 0x030000
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: reg 0x10: [mem 0xdb000000-0xdbffffff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: reg 0x18: [mem 0x90000000-0x9fffffff 64bit pref]
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: BAR 2: assigned to efifb
[Fri Mar  8 13:00:57 2019] pci 0000:00:04.0: [8086:1903] type 00 class 0x118000
[Fri Mar  8 13:00:57 2019] pci 0000:00:04.0: reg 0x10: [mem 0xdc420000-0xdc427fff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
[Fri Mar  8 13:00:57 2019] pci 0000:00:14.0: reg 0x10: [mem 0xdc410000-0xdc41ffff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:14.0: PME# supported from D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
[Fri Mar  8 13:00:57 2019] pci 0000:00:14.2: reg 0x10: [mem 0xdc434000-0xdc434fff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:15.0: [8086:9d60] type 00 class 0x118000
[Fri Mar  8 13:00:57 2019] pci 0000:00:15.0: reg 0x10: [mem 0xdc433000-0xdc433fff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:15.1: [8086:9d61] type 00 class 0x118000
[Fri Mar  8 13:00:57 2019] pci 0000:00:15.1: reg 0x10: [mem 0xdc432000-0xdc432fff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
[Fri Mar  8 13:00:57 2019] pci 0000:00:16.0: reg 0x10: [mem 0xdc431000-0xdc431fff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:16.0: PME# supported from D3hot
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: [8086:9d10] type 01 class 0x060400
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: Intel SPT PCH root port ACS workaround enabled
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4: [8086:9d14] type 01 class 0x060400
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4: Intel SPT PCH root port ACS workaround enabled
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5: [8086:9d15] type 01 class 0x060400
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5: Intel SPT PCH root port ACS workaround enabled
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0: [8086:9d18] type 01 class 0x060400
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0: Intel SPT PCH root port ACS workaround enabled
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.0: [8086:9d58] type 00 class 0x060100
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.2: reg 0x10: [mem 0xdc42c000-0xdc42ffff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.3: [8086:9d71] type 00 class 0x040380
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.3: reg 0x10: [mem 0xdc428000-0xdc42bfff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.3: reg 0x20: [mem 0xdc400000-0xdc40ffff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.4: reg 0x10: [mem 0xdc430000-0xdc4300ff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1f.4: reg 0x20: [io  0xf040-0xf05f]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: PCI bridge to [bus 01-39]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xda0fffff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0:   bridge window [mem 0xa0000000-0xc1ffffff 64bit pref]
[Fri Mar  8 13:00:57 2019] pci 0000:3a:00.0: [168c:003e] type 00 class 0x028000
[Fri Mar  8 13:00:57 2019] pci 0000:3a:00.0: reg 0x10: [mem 0xdc000000-0xdc1fffff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:3a:00.0: PME# supported from D0 D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4: PCI bridge to [bus 3a]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4:   bridge window [mem 0xdc000000-0xdc1fffff]
[Fri Mar  8 13:00:57 2019] pci 0000:3b:00.0: [10ec:525a] type 00 class 0xff0000
[Fri Mar  8 13:00:57 2019] pci 0000:3b:00.0: reg 0x14: [mem 0xdc300000-0xdc300fff]
[Fri Mar  8 13:00:57 2019] pci 0000:3b:00.0: supports D1 D2
[Fri Mar  8 13:00:57 2019] pci 0000:3b:00.0: PME# supported from D1 D2 D3hot D3cold
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5: PCI bridge to [bus 3b]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5:   bridge window [mem 0xdc300000-0xdc3fffff]
[Fri Mar  8 13:00:57 2019] pci 0000:3c:00.0: [144d:a804] type 00 class 0x010802
[Fri Mar  8 13:00:57 2019] pci 0000:3c:00.0: reg 0x10: [mem 0xdc200000-0xdc203fff 64bit]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0: PCI bridge to [bus 3c]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0:   bridge window [mem 0xdc200000-0xdc2fffff]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: on NUMA node 0
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
[Fri Mar  8 13:00:57 2019] ACPI: EC: interrupt unblocked
[Fri Mar  8 13:00:57 2019] ACPI: EC: event unblocked
[Fri Mar  8 13:00:57 2019] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x14, EC_CMD/EC_SC=0x934, EC_DATA=0x930
[Fri Mar  8 13:00:57 2019] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions and events
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: vgaarb: bridge control possible
[Fri Mar  8 13:00:57 2019] vgaarb: loaded
[Fri Mar  8 13:00:57 2019] SCSI subsystem initialized
[Fri Mar  8 13:00:57 2019] libata version 3.00 loaded.
[Fri Mar  8 13:00:57 2019] ACPI: bus type USB registered
[Fri Mar  8 13:00:57 2019] usbcore: registered new interface driver usbfs
[Fri Mar  8 13:00:57 2019] usbcore: registered new interface driver hub
[Fri Mar  8 13:00:57 2019] usbcore: registered new device driver usb
[Fri Mar  8 13:00:57 2019] pps_core: LinuxPPS API ver. 1 registered
[Fri Mar  8 13:00:57 2019] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[Fri Mar  8 13:00:57 2019] PTP clock support registered
[Fri Mar  8 13:00:57 2019] Registered efivars operations
[Fri Mar  8 13:00:57 2019] Advanced Linux Sound Architecture Driver Initialized.
[Fri Mar  8 13:00:57 2019] PCI: Using ACPI for IRQ routing
[Fri Mar  8 13:00:57 2019] PCI: pci_cache_line_size set to 64 bytes
[Fri Mar  8 13:00:57 2019] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[Fri Mar  8 13:00:57 2019] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[Fri Mar  8 13:00:57 2019] e820: reserve RAM buffer [mem 0x5f2b9000-0x5fffffff]
[Fri Mar  8 13:00:57 2019] e820: reserve RAM buffer [mem 0x70875000-0x73ffffff]
[Fri Mar  8 13:00:57 2019] e820: reserve RAM buffer [mem 0x7b600000-0x7bffffff]
[Fri Mar  8 13:00:57 2019] e820: reserve RAM buffer [mem 0x27e800000-0x27fffffff]
[Fri Mar  8 13:00:57 2019] Bluetooth: Core ver 2.22
[Fri Mar  8 13:00:57 2019] NET: Registered protocol family 31
[Fri Mar  8 13:00:57 2019] Bluetooth: HCI device and connection manager initialized
[Fri Mar  8 13:00:57 2019] Bluetooth: HCI socket layer initialized
[Fri Mar  8 13:00:57 2019] Bluetooth: L2CAP socket layer initialized
[Fri Mar  8 13:00:57 2019] Bluetooth: SCO socket layer initialized
[Fri Mar  8 13:00:57 2019] NetLabel: Initializing
[Fri Mar  8 13:00:57 2019] NetLabel:  domain hash size = 128
[Fri Mar  8 13:00:57 2019] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[Fri Mar  8 13:00:57 2019] NetLabel:  unlabeled traffic allowed by default
[Fri Mar  8 13:00:57 2019] wmi_bus wmi_bus-PNP0C14:01: WQBC data block query control method not found
[Fri Mar  8 13:00:57 2019] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[Fri Mar  8 13:00:57 2019] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[Fri Mar  8 13:00:57 2019] clocksource: Switched to clocksource tsc-early
[Fri Mar  8 13:00:57 2019] AppArmor: AppArmor Filesystem Enabled
[Fri Mar  8 13:00:57 2019] pnp: PnP ACPI init
[Fri Mar  8 13:00:57 2019] system 00:00: [io  0x0680-0x069f] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:00: [io  0xffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:00: [io  0xffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:00: [io  0xffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:00: [io  0x1800-0x18fe] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:00: [io  0x164e-0x164f] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[Fri Mar  8 13:00:57 2019] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[Fri Mar  8 13:00:57 2019] system 00:02: [io  0x1854-0x1857] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[Fri Mar  8 13:00:57 2019] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[Fri Mar  8 13:00:57 2019] pnp 00:04: Plug and Play ACPI device, IDs DLL075b PNP0f13 (active)
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfed90000-0xfed93fff] could not be reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xfee00000-0xfeefffff] could not be reserved
[Fri Mar  8 13:00:57 2019] system 00:05: [mem 0xdffe0000-0xdfffffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfe000000-0xfe01ffff] could not be reserved
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[Fri Mar  8 13:00:57 2019] system 00:07: [io  0xff00-0xfffe] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[Fri Mar  8 13:00:57 2019] system 00:08: [mem 0xfe029000-0xfe029fff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:08: [mem 0xfe028000-0xfe028fff] has been reserved
[Fri Mar  8 13:00:57 2019] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[Fri Mar  8 13:00:57 2019] pnp: PnP ACPI: found 9 devices
[Fri Mar  8 13:00:57 2019] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 01-39] add_size 1000
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0: PCI bridge to [bus 01-39]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0:   bridge window [mem 0xc4000000-0xda0fffff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.0:   bridge window [mem 0xa0000000-0xc1ffffff 64bit pref]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4: PCI bridge to [bus 3a]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.4:   bridge window [mem 0xdc000000-0xdc1fffff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5: PCI bridge to [bus 3b]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1c.5:   bridge window [mem 0xdc300000-0xdc3fffff]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0: PCI bridge to [bus 3c]
[Fri Mar  8 13:00:57 2019] pci 0000:00:1d.0:   bridge window [mem 0xdc200000-0xdc2fffff]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 15 [mem 0x7f800000-0xdfffffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:00: resource 16 [mem 0xfd000000-0xfe7fffff window]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:01: resource 1 [mem 0xc4000000-0xda0fffff]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:01: resource 2 [mem 0xa0000000-0xc1ffffff 64bit pref]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:3a: resource 1 [mem 0xdc000000-0xdc1fffff]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:3b: resource 1 [mem 0xdc300000-0xdc3fffff]
[Fri Mar  8 13:00:57 2019] pci_bus 0000:3c: resource 1 [mem 0xdc200000-0xdc2fffff]
[Fri Mar  8 13:00:57 2019] NET: Registered protocol family 2
[Fri Mar  8 13:00:57 2019] tcp_listen_portaddr_hash hash table entries: 4096 (order: 4, 65536 bytes)
[Fri Mar  8 13:00:57 2019] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[Fri Mar  8 13:00:57 2019] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[Fri Mar  8 13:00:57 2019] TCP: Hash tables configured (established 65536 bind 65536)
[Fri Mar  8 13:00:57 2019] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[Fri Mar  8 13:00:57 2019] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[Fri Mar  8 13:00:57 2019] NET: Registered protocol family 1
[Fri Mar  8 13:00:57 2019] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[Fri Mar  8 13:00:57 2019] PCI: CLS 0 bytes, default 64
[Fri Mar  8 13:00:57 2019] Unpacking initramfs...
[Fri Mar  8 13:00:57 2019] Freeing initrd memory: 15748K
[Fri Mar  8 13:00:57 2019] DMAR: ACPI device "device:79" under DMAR at fed91000 as 00:15.0
[Fri Mar  8 13:00:57 2019] DMAR: ACPI device "device:7a" under DMAR at fed91000 as 00:15.1
[Fri Mar  8 13:00:57 2019] DMAR: No ATSR found
[Fri Mar  8 13:00:57 2019] DMAR: dmar0: Using Queued invalidation
[Fri Mar  8 13:00:57 2019] DMAR: dmar1: Using Queued invalidation
[Fri Mar  8 13:00:57 2019] DMAR: Setting RMRR:
[Fri Mar  8 13:00:57 2019] DMAR: Setting identity map for device 0000:00:02.0 [0x7d000000 - 0x7f7fffff]
[Fri Mar  8 13:00:57 2019] DMAR: Setting identity map for device 0000:00:14.0 [0x70957000 - 0x70976fff]
[Fri Mar  8 13:00:57 2019] DMAR: Prepare 0-16MiB unity mapping for LPC
[Fri Mar  8 13:00:57 2019] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[Fri Mar  8 13:00:57 2019] DMAR: Intel(R) Virtualization Technology for Directed I/O
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:00.0 to group 0
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:02.0 to group 1
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:04.0 to group 2
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:14.0 to group 3
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:14.2 to group 3
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:15.0 to group 4
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:15.1 to group 4
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:16.0 to group 5
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1c.0 to group 6
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1c.4 to group 7
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1c.5 to group 8
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1d.0 to group 9
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1f.0 to group 10
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1f.2 to group 10
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1f.3 to group 10
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:00:1f.4 to group 10
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:3a:00.0 to group 11
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:3b:00.0 to group 12
[Fri Mar  8 13:00:57 2019] iommu: Adding device 0000:3c:00.0 to group 13
[Fri Mar  8 13:00:57 2019] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
[Fri Mar  8 13:00:57 2019] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[Fri Mar  8 13:00:57 2019] RAPL PMU: hw unit of domain package 2^-14 Joules
[Fri Mar  8 13:00:57 2019] RAPL PMU: hw unit of domain dram 2^-14 Joules
[Fri Mar  8 13:00:57 2019] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[Fri Mar  8 13:00:57 2019] RAPL PMU: hw unit of domain psys 2^-14 Joules
[Fri Mar  8 13:00:57 2019] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2717868ea45, max_idle_ns: 440795316085 ns
[Fri Mar  8 13:00:57 2019] clocksource: Switched to clocksource tsc
[Fri Mar  8 13:00:57 2019] check: Scanning for low memory corruption every 60 seconds
[Fri Mar  8 13:00:57 2019] Initialise system trusted keyrings
[Fri Mar  8 13:00:57 2019] workingset: timestamp_bits=46 max_order=21 bucket_order=0
[Fri Mar  8 13:00:57 2019] fuse init (API version 7.28)
[Fri Mar  8 13:00:57 2019] NET: Registered protocol family 38
[Fri Mar  8 13:00:57 2019] async_tx: api initialized (async)
[Fri Mar  8 13:00:57 2019] Key type asymmetric registered
[Fri Mar  8 13:00:57 2019] Asymmetric key parser 'x509' registered
[Fri Mar  8 13:00:57 2019] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[Fri Mar  8 13:00:57 2019] io scheduler kyber registered
[Fri Mar  8 13:00:57 2019] aer 0000:00:1c.0:pcie002: AER enabled with IRQ 122
[Fri Mar  8 13:00:57 2019] aer 0000:00:1c.4:pcie002: AER enabled with IRQ 123
[Fri Mar  8 13:00:57 2019] aer 0000:00:1c.5:pcie002: AER enabled with IRQ 124
[Fri Mar  8 13:00:57 2019] aer 0000:00:1d.0:pcie002: AER enabled with IRQ 125
[Fri Mar  8 13:00:57 2019] efifb: probing for efifb
[Fri Mar  8 13:00:57 2019] efifb: framebuffer at 0x90000000, using 8128k, total 8128k
[Fri Mar  8 13:00:57 2019] efifb: mode is 1920x1080x32, linelength=7680, pages=1
[Fri Mar  8 13:00:57 2019] efifb: scrolling: redraw
[Fri Mar  8 13:00:57 2019] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[Fri Mar  8 13:00:57 2019] Console: switching to colour frame buffer device 240x67
[Fri Mar  8 13:00:57 2019] fb0: EFI VGA frame buffer device
[Fri Mar  8 13:00:57 2019] intel_idle: MWAIT substates: 0x11142120
[Fri Mar  8 13:00:57 2019] intel_idle: v0.4.1 model 0x8E
[Fri Mar  8 13:00:57 2019] intel_idle: lapic_timer_reliable_states 0xffffffff
[Fri Mar  8 13:00:57 2019] ACPI: AC Adapter [AC] (on-line)
[Fri Mar  8 13:00:57 2019] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[Fri Mar  8 13:00:57 2019] ACPI: Lid Switch [LID0]
[Fri Mar  8 13:00:57 2019] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[Fri Mar  8 13:00:57 2019] ACPI: Power Button [PBTN]
[Fri Mar  8 13:00:57 2019] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[Fri Mar  8 13:00:57 2019] ACPI: Sleep Button [SBTN]
[Fri Mar  8 13:00:57 2019] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[Fri Mar  8 13:00:57 2019] ACPI: Power Button [PWRF]
[Fri Mar  8 13:00:57 2019] thermal LNXTHERM:00: registered as thermal_zone0
[Fri Mar  8 13:00:57 2019] ACPI: Thermal Zone [THM] (25 C)
[Fri Mar  8 13:00:57 2019] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[Fri Mar  8 13:00:57 2019] Non-volatile memory driver v1.3
[Fri Mar  8 13:00:57 2019] [drm] VT-d active for gfx access
[Fri Mar  8 13:00:57 2019] checking generic (90000000 7f0000) vs hw (90000000 10000000)
[Fri Mar  8 13:00:57 2019] fb0: switching to inteldrmfb from EFI VGA
[Fri Mar  8 13:00:57 2019] Console: switching to colour dummy device 80x25
[Fri Mar  8 13:00:57 2019] [drm] Replacing VGA console driver
[Fri Mar  8 13:00:58 2019] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[Fri Mar  8 13:00:58 2019] [drm] Driver supports precise vblank timestamp query.
[Fri Mar  8 13:00:58 2019] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[Fri Mar  8 13:00:58 2019] i915 0000:00:02.0: Direct firmware load for i915/kbl_dmc_ver1_04.bin failed with error -2
[Fri Mar  8 13:00:58 2019] i915 0000:00:02.0: Failed to load DMC firmware i915/kbl_dmc_ver1_04.bin. Disabling runtime power management.
[Fri Mar  8 13:00:58 2019] i915 0000:00:02.0: DMC firmware homepage: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/i915
[Fri Mar  8 13:00:58 2019] [drm] Initialized i915 1.6.0 20181204 for 0000:00:02.0 on minor 0
[Fri Mar  8 13:00:58 2019] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[Fri Mar  8 13:00:58 2019] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[Fri Mar  8 13:00:58 2019] fbcon: inteldrmfb (fb0) is primary device
[Fri Mar  8 13:00:58 2019] loop: module loaded
[Fri Mar  8 13:00:58 2019] rtsx_pci 0000:3b:00.0: enabling device (0000 -> 0002)
[Fri Mar  8 13:00:58 2019] battery: ACPI: Battery Slot [BAT0] (battery present)
[Fri Mar  8 13:00:58 2019] intel-lpss 0000:00:15.0: enabling device (0000 -> 0002)
[Fri Mar  8 13:00:58 2019] intel-lpss 0000:00:15.0: Failed to create debugfs entries
[Fri Mar  8 13:00:58 2019] intel-lpss 0000:00:15.1: enabling device (0000 -> 0002)
[Fri Mar  8 13:00:58 2019] intel-lpss 0000:00:15.1: Failed to create debugfs entries
[Fri Mar  8 13:00:58 2019] nvme nvme0: pci function 0000:3c:00.0
[Fri Mar  8 13:00:58 2019] tun: Universal TUN/TAP device driver, 1.6
[Fri Mar  8 13:00:58 2019] PPP generic driver version 2.4.2
[Fri Mar  8 13:00:58 2019] PPP MPPE Compression module registered
[Fri Mar  8 13:00:58 2019] NET: Registered protocol family 24
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: enabling device (0000 -> 0002)
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
[Fri Mar  8 13:00:58 2019] uhci_hcd: USB Universal Host Controller Interface driver
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: xHCI Host Controller
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x0000000001109810
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[Fri Mar  8 13:00:58 2019] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.00
[Fri Mar  8 13:00:58 2019] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[Fri Mar  8 13:00:58 2019] usb usb1: Product: xHCI Host Controller
[Fri Mar  8 13:00:58 2019] usb usb1: Manufacturer: Linux 5.0.0-ARCH xhci-hcd
[Fri Mar  8 13:00:58 2019] usb usb1: SerialNumber: 0000:00:14.0
[Fri Mar  8 13:00:58 2019] hub 1-0:1.0: USB hub found
[Fri Mar  8 13:00:58 2019] hub 1-0:1.0: 12 ports detected
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: xHCI Host Controller
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[Fri Mar  8 13:00:58 2019] xhci_hcd 0000:00:14.0: Host supports USB 3.0  SuperSpeed
[Fri Mar  8 13:00:58 2019] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.00
[Fri Mar  8 13:00:58 2019] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[Fri Mar  8 13:00:58 2019] usb usb2: Product: xHCI Host Controller
[Fri Mar  8 13:00:58 2019] usb usb2: Manufacturer: Linux 5.0.0-ARCH xhci-hcd
[Fri Mar  8 13:00:58 2019] usb usb2: SerialNumber: 0000:00:14.0
[Fri Mar  8 13:00:58 2019] hub 2-0:1.0: USB hub found
[Fri Mar  8 13:00:58 2019] hub 2-0:1.0: 6 ports detected
[Fri Mar  8 13:00:58 2019] usb: port power management may be unreliable
[Fri Mar  8 13:00:58 2019] usbcore: registered new interface driver cdc_acm
[Fri Mar  8 13:00:58 2019] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[Fri Mar  8 13:00:58 2019] usbcore: registered new interface driver usb-storage
[Fri Mar  8 13:00:58 2019] usbcore: registered new interface driver usbserial_generic
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for generic
[Fri Mar  8 13:00:58 2019] usbcore: registered new interface driver cp210x
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for cp210x
[Fri Mar  8 13:00:58 2019] usbcore: registered new interface driver ftdi_sio
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for FTDI USB Serial Device
[Fri Mar  8 13:00:58 2019] usbcore: registered new interface driver usb_serial_simple
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for carelink
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for zio
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for funsoft
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for flashloader
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for google
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for libtransistor
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for vivopay
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for moto_modem
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for motorola_tetra
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for novatel_gps
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for hp4x
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for suunto
[Fri Mar  8 13:00:58 2019] usbserial: USB Serial support registered for siemens_mpi
[Fri Mar  8 13:00:58 2019] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[Fri Mar  8 13:00:58 2019] i8042: Warning: Keylock active
[Fri Mar  8 13:00:58 2019] serio: i8042 KBD port at 0x60,0x64 irq 1
[Fri Mar  8 13:00:58 2019] serio: i8042 AUX port at 0x60,0x64 irq 12
[Fri Mar  8 13:00:58 2019] rtc_cmos 00:01: RTC can wake from S4
[Fri Mar  8 13:00:58 2019] rtc_cmos 00:01: registered as rtc0
[Fri Mar  8 13:00:58 2019] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram
[Fri Mar  8 13:00:58 2019] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[Fri Mar  8 13:00:58 2019] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[Fri Mar  8 13:00:58 2019] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[Fri Mar  8 13:00:58 2019] nvme nvme0: 2/0/0 default/read/poll queues
[Fri Mar  8 13:00:58 2019]  nvme0n1: p1 p2
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1a56:1535
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: kconfig debug 0 debugfs 0 tracing 0 dfs 0 testmode 0
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: firmware ver RM.4.4.1.c2-00057-QCARMSWP-1 api 6 features wowlan,ignore-otp,no-4addr-pad,raw-mode crc32 e061250a
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: board_file api 2 bmi_id N/A crc32 4ed3569e
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: unsupported HTC service id: 1536
[Fri Mar  8 13:00:58 2019] DMAR: DRHD: handling fault status reg 2
[Fri Mar  8 13:00:58 2019] DMAR: [DMA Write] Request device [3a:00.0] fault addr 0 [fault reason 05] PTE Write access is not set
[Fri Mar  8 13:00:58 2019] ath10k_pci 0000:3a:00.0: htt-ver 3.56 wmi-op 4 htt-op 3 cal otp max-sta 32 raw 0 hwcrypto 1
[Fri Mar  8 13:00:58 2019] ath: EEPROM regdomain: 0x6c
[Fri Mar  8 13:00:58 2019] ath: EEPROM indicates we should expect a direct regpair map
[Fri Mar  8 13:00:58 2019] ath: Country alpha2 being used: 00
[Fri Mar  8 13:00:58 2019] ath: Regpair used: 0x6c
[Fri Mar  8 13:00:59 2019] psmouse serio1: synaptics: queried max coordinates: x [..5666], y [..4734]
[Fri Mar  8 13:00:59 2019] psmouse serio1: synaptics: queried min coordinates: x [1276..], y [1118..]
[Fri Mar  8 13:00:59 2019] psmouse serio1: synaptics: Your touchpad (PNP: DLL075b PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
[Fri Mar  8 13:00:59 2019] Console: switching to colour frame buffer device 240x67
[Fri Mar  8 13:00:59 2019] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.2, id: 0x1e2a1, caps: 0xf00323/0x840300/0x12e800/0x0, board id: 3038, fw id: 2375007
[Fri Mar  8 13:00:59 2019] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[Fri Mar  8 13:00:59 2019] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
[Fri Mar  8 13:00:59 2019] proc_thermal 0000:00:04.0: enabling device (0000 -> 0002)
[Fri Mar  8 13:00:59 2019] proc_thermal 0000:00:04.0: Creating sysfs group for PROC_THERMAL_PCI
[Fri Mar  8 13:00:59 2019] device-mapper: uevent: version 1.0.3
[Fri Mar  8 13:00:59 2019] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
[Fri Mar  8 13:00:59 2019] device-mapper: raid: Loading target version 1.14.0
[Fri Mar  8 13:00:59 2019] intel_pstate: Intel P-state driver initializing
[Fri Mar  8 13:00:59 2019] intel_pstate: HWP enabled
[Fri Mar  8 13:00:59 2019] EFI Variables Facility v0.08 2004-May-17
[Fri Mar  8 13:00:59 2019] hidraw: raw HID events driver (C) Jiri Kosina
[Fri Mar  8 13:00:59 2019] usbcore: registered new interface driver usbhid
[Fri Mar  8 13:00:59 2019] usbhid: USB HID core driver
[Fri Mar  8 13:00:59 2019] snd_hda_intel 0000:00:1f.3: enabling device (0000 -> 0002)
[Fri Mar  8 13:00:59 2019] snd_hda_intel 0000:00:1f.3: Linked as a consumer to 0000:00:02.0
[Fri Mar  8 13:00:59 2019] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops 0xffffffffa8aa22c0)
[Fri Mar  8 13:00:59 2019] Initializing XFRM netlink socket
[Fri Mar  8 13:00:59 2019] NET: Registered protocol family 10
[Fri Mar  8 13:00:59 2019] Segment Routing with IPv6
[Fri Mar  8 13:00:59 2019] NET: Registered protocol family 17
[Fri Mar  8 13:00:59 2019] Bluetooth: RFCOMM socket layer initialized
[Fri Mar  8 13:00:59 2019] Bluetooth: RFCOMM ver 1.11
[Fri Mar  8 13:00:59 2019] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[Fri Mar  8 13:00:59 2019] Bluetooth: HIDP socket layer initialized
[Fri Mar  8 13:00:59 2019] microcode: sig=0x806e9, pf=0x80, revision=0x8e
[Fri Mar  8 13:00:59 2019] microcode: Microcode Update Driver: v2.2.
[Fri Mar  8 13:00:59 2019] AVX2 version of gcm_enc/dec engaged.
[Fri Mar  8 13:00:59 2019] AES CTR mode by8 optimization enabled
[Fri Mar  8 13:00:59 2019] sched_clock: Marking stable (6522980665, -9248231)->(6528996135, -15263701)
[Fri Mar  8 13:00:59 2019] registered taskstats version 1
[Fri Mar  8 13:00:59 2019] Loading compiled-in X.509 certificates
[Fri Mar  8 13:00:59 2019] Loaded X.509 cert 'Modules: 1e677c2b8e60cb9391ce5268b5395d06c974f545'
[Fri Mar  8 13:00:59 2019] Btrfs loaded, crc32c=crc32c-intel
[Fri Mar  8 13:00:59 2019] AppArmor: AppArmor sha1 policy hashing enabled
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC3246: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:      Headset Mic=0x19
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:      Headphone Mic=0x1a
[Fri Mar  8 13:00:59 2019] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
[Fri Mar  8 13:00:59 2019] input: HDA Intel PCH Headphone Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input8
[Fri Mar  8 13:00:59 2019] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input9
[Fri Mar  8 13:00:59 2019] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input10
[Fri Mar  8 13:00:59 2019] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input11
[Fri Mar  8 13:00:59 2019] input: HDA Intel PCH HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input12
[Fri Mar  8 13:00:59 2019] input: HDA Intel PCH HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input13
[Fri Mar  8 13:00:59 2019] input: Dell WMI hotkeys as /devices/platform/PNP0C14:01/wmi_bus/wmi_bus-PNP0C14:01/9DBB5994-A997-11DA-B012-B622A1EF5492/input/input14
[Fri Mar  8 13:00:59 2019] ALSA device list:
[Fri Mar  8 13:00:59 2019]   #0: HDA Intel PCH at 0xdc428000 irq 133
[Fri Mar  8 13:00:59 2019] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[Fri Mar  8 13:00:59 2019] cfg80211: failed to load regulatory.db
[Fri Mar  8 13:00:59 2019] Freeing unused kernel image memory: 976K
[Fri Mar  8 13:00:59 2019] Write protecting the kernel read-only data: 22528k
[Fri Mar  8 13:00:59 2019] Freeing unused kernel image memory: 2008K
[Fri Mar  8 13:00:59 2019] Freeing unused kernel image memory: 2040K
[Fri Mar  8 13:00:59 2019] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[Fri Mar  8 13:00:59 2019] x86/mm: Checking user space page tables
[Fri Mar  8 13:00:59 2019] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[Fri Mar  8 13:00:59 2019] Run /init as init process
[Fri Mar  8 13:01:29 2019] device-mapper: crypt: xts(aes) using implementation "xts-aes-aesni"
[Fri Mar  8 13:01:29 2019] BTRFS: device label lxc devid 1 transid 1335 /dev/dm-4
[Fri Mar  8 13:01:29 2019] BTRFS: device label root devid 1 transid 515878 /dev/dm-1
[Fri Mar  8 13:01:29 2019] BTRFS: device label home devid 1 transid 933832 /dev/dm-3
[Fri Mar  8 13:01:29 2019] BTRFS info (device dm-1): enabling auto defrag
[Fri Mar  8 13:01:29 2019] BTRFS info (device dm-1): enabling ssd optimizations
[Fri Mar  8 13:01:29 2019] BTRFS info (device dm-1): using free space tree
[Fri Mar  8 13:01:29 2019] BTRFS info (device dm-1): has skinny extents
[Fri Mar  8 13:01:29 2019] systemd[1]: systemd 241.7-9-arch running in system mode. (+PAM +AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
[Fri Mar  8 13:01:29 2019] systemd[1]: Detected architecture x86-64.
[Fri Mar  8 13:01:29 2019] systemd[1]: Set hostname to <xps>.
[Fri Mar  8 13:01:29 2019] systemd[1]: /etc/systemd/system/chronyd.service:9: PIDFile= references path below legacy directory /var/run/, updating /var/run/chrony/chronyd.pid → /run/chrony/chronyd.pid; please update the unit file accordingly.
[Fri Mar  8 13:01:29 2019] systemd[1]: Condition check resulted in Arbitrary Executable File Formats File System Automount Point being skipped.
[Fri Mar  8 13:01:29 2019] systemd[1]: Listening on Journal Socket (/dev/log).
[Fri Mar  8 13:01:29 2019] systemd[1]: Reached target Remote File Systems.
[Fri Mar  8 13:01:29 2019] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[Fri Mar  8 13:01:29 2019] systemd[1]: Listening on initctl Compatibility Named Pipe.
[Fri Mar  8 13:01:29 2019] systemd[1]: Listening on Network Service Netlink Socket.
[Fri Mar  8 13:01:29 2019] BTRFS info (device dm-1): using free space tree
[Fri Mar  8 13:01:29 2019] audit: type=1130 audit(1552039290.807:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:29 2019] audit: type=1130 audit(1552039290.817:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-remount-fs comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:29 2019] audit: type=1130 audit(1552039290.847:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=kmod-static-nodes comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:29 2019] audit: type=1130 audit(1552039290.867:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=lvm2-lvmetad comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:30 2019] audit: type=1130 audit(1552039290.917:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:30 2019] audit: type=1130 audit(1552039290.937:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-random-seed comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:30 2019] audit: type=1130 audit(1552039290.967:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-sysusers comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:30 2019] systemd-journald[350]: Received request to flush runtime journal from PID 1
[Fri Mar  8 13:01:30 2019] audit: type=1130 audit(1552039290.987:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:30 2019] audit: type=1130 audit(1552039291.027:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj==unconfined msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[Fri Mar  8 13:01:30 2019] audit: type=1400 audit(1552039291.047:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="ping" pid=379 comm="apparmor_parser"
[Fri Mar  8 13:01:30 2019] ath10k_pci 0000:3a:00.0 wlp58s0: renamed from wlan0
[Fri Mar  8 13:01:30 2019] BTRFS info (device dm-1): device fsid 1cde2a06-85f5-4938-954b-1cca997037fc devid 1 moved old:/dev/mapper/xps-root new:/dev/dm-1
[Fri Mar  8 13:01:30 2019] BTRFS info (device dm-1): device fsid 1cde2a06-85f5-4938-954b-1cca997037fc devid 1 moved old:/dev/dm-1 new:/dev/mapper/xps-root
[Fri Mar  8 13:01:30 2019] Adding 4194300k swap on /dev/mapper/xps-swap.  Priority:-2 extents:1 across:4194300k SS
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-4): enabling ssd optimizations
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-4): enabling auto defrag
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-4): using free space tree
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-4): has skinny extents
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-3): enabling ssd optimizations
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-3): enabling auto defrag
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-3): using free space tree
[Fri Mar  8 13:01:31 2019] BTRFS info (device dm-3): has skinny extents
[Fri Mar  8 13:01:32 2019] BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
[Fri Mar  8 13:01:32 2019] #PF error: [normal kernel read fault]
[Fri Mar  8 13:01:32 2019] PGD 0 P4D 0 
[Fri Mar  8 13:01:32 2019] Oops: 0000 [#1] SMP PTI
[Fri Mar  8 13:01:32 2019] CPU: 0 PID: 794 Comm: nft Tainted: G                T 5.0.0-ARCH #2
[Fri Mar  8 13:01:32 2019] Hardware name: Dell Inc. XPS 13 9360/05HM5Y, BIOS 2.10.0 09/27/2018
[Fri Mar  8 13:01:32 2019] RIP: 0010:nft_set_elem_destroy+0x3c/0x110
[Fri Mar  8 13:01:32 2019] Code: 38 65 48 8b 04 25 28 00 00 00 48 89 44 24 30 31 c0 48 8b 85 80 00 00 00 48 c7 44 24 28 00 00 00 00 48 c7 44 24 08 00 00 00 00 <8b> 58 70 48 c7 44 24 10 00 00 00 00 48 8b 45 28 48 c7 44 24 18 00
[Fri Mar  8 13:01:32 2019] RSP: 0018:ffff95de406276e0 EFLAGS: 00010246
[Fri Mar  8 13:01:32 2019] RAX: 0000000000000000 RBX: ffff8cf2efd78468 RCX: dead000000000200
[Fri Mar  8 13:01:32 2019] RDX: 0000000000000001 RSI: ffff8cf2eacbb008 RDI: ffff8cf2eae70000
[Fri Mar  8 13:01:32 2019] RBP: ffff8cf2eae70000 R08: 0000000000000000 R09: ffff8cf2eb117700
[Fri Mar  8 13:01:32 2019] R10: ffff8cf2eb117788 R11: 0000000000000001 R12: ffff8cf2eacbb008
[Fri Mar  8 13:01:32 2019] R13: 0000000000000001 R14: dead000000000100 R15: ffffffffa9088170
[Fri Mar  8 13:01:32 2019] FS:  00007808b73ed740(0000) GS:ffff8cf2f6200000(0000) knlGS:0000000000000000
[Fri Mar  8 13:01:32 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Mar  8 13:01:32 2019] CR2: 0000000000000070 CR3: 0000000272cf8002 CR4: 00000000003606f0
[Fri Mar  8 13:01:32 2019] Call Trace:
[Fri Mar  8 13:01:32 2019]  ? nf_tables_expr_destroy+0x1f/0x40
[Fri Mar  8 13:01:32 2019]  __nf_tables_abort+0x18b/0x6f0
[Fri Mar  8 13:01:32 2019]  ? deactivate_slab.isra.73+0x42f/0x610
[Fri Mar  8 13:01:32 2019]  nft_request_module+0x43/0xe0
[Fri Mar  8 13:01:32 2019]  ? __nla_parse+0xf4/0x130
[Fri Mar  8 13:01:32 2019]  ? nla_strcmp+0x10/0x50
[Fri Mar  8 13:01:32 2019]  nft_chain_parse_hook+0x1a5/0x200
[Fri Mar  8 13:01:32 2019]  nf_tables_addchain.constprop.71+0x80/0x580
[Fri Mar  8 13:01:32 2019]  nf_tables_newchain+0x49f/0x540
[Fri Mar  8 13:01:32 2019]  nfnetlink_rcv_batch+0x4d2/0x690
[Fri Mar  8 13:01:32 2019]  ? __nla_parse+0x37/0x130
[Fri Mar  8 13:01:32 2019]  ? nla_parse+0x33/0x40
[Fri Mar  8 13:01:32 2019]  nfnetlink_rcv+0x104/0x140
[Fri Mar  8 13:01:32 2019]  netlink_unicast+0x1b8/0x250
[Fri Mar  8 13:01:32 2019]  netlink_sendmsg+0x206/0x3c0
[Fri Mar  8 13:01:32 2019]  sock_sendmsg+0x34/0x40
[Fri Mar  8 13:01:32 2019]  ___sys_sendmsg+0x268/0x280
[Fri Mar  8 13:01:32 2019]  __sys_sendmsg+0x67/0xb0
[Fri Mar  8 13:01:32 2019]  do_syscall_64+0x60/0x3c3
[Fri Mar  8 13:01:32 2019]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[Fri Mar  8 13:01:32 2019] RIP: 0033:0x7808b783e368
[Fri Mar  8 13:01:32 2019] Code: 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 d5 91 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 41 89 d4 55
[Fri Mar  8 13:01:32 2019] RSP: 002b:00007ffd3bf7c9f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[Fri Mar  8 13:01:32 2019] RAX: ffffffffffffffda RBX: 00007ffd3bf7ca10 RCX: 00007808b783e368
[Fri Mar  8 13:01:32 2019] RDX: 0000000000000000 RSI: 00007ffd3bf7da70 RDI: 0000000000000003
[Fri Mar  8 13:01:32 2019] RBP: 00007ffd3bf7db70 R08: 0000000000000004 R09: 0000000000000007
[Fri Mar  8 13:01:32 2019] R10: 00007ffd3bf7da5c R11: 0000000000000246 R12: 00007ffd3bf7dbe0
[Fri Mar  8 13:01:32 2019] R13: 00007ffd3bf7ca10 R14: 00007ffd3bf7ca10 R15: 00005b1ace7d39f0
[Fri Mar  8 13:01:32 2019] Modules linked in:
[Fri Mar  8 13:01:32 2019] CR2: 0000000000000070
[Fri Mar  8 13:01:32 2019] ---[ end trace 75f0e86bd8f77909 ]---
[Fri Mar  8 13:01:32 2019] RIP: 0010:nft_set_elem_destroy+0x3c/0x110
[Fri Mar  8 13:01:32 2019] Code: 38 65 48 8b 04 25 28 00 00 00 48 89 44 24 30 31 c0 48 8b 85 80 00 00 00 48 c7 44 24 28 00 00 00 00 48 c7 44 24 08 00 00 00 00 <8b> 58 70 48 c7 44 24 10 00 00 00 00 48 8b 45 28 48 c7 44 24 18 00
[Fri Mar  8 13:01:32 2019] RSP: 0018:ffff95de406276e0 EFLAGS: 00010246
[Fri Mar  8 13:01:32 2019] RAX: 0000000000000000 RBX: ffff8cf2efd78468 RCX: dead000000000200
[Fri Mar  8 13:01:32 2019] RDX: 0000000000000001 RSI: ffff8cf2eacbb008 RDI: ffff8cf2eae70000
[Fri Mar  8 13:01:32 2019] RBP: ffff8cf2eae70000 R08: 0000000000000000 R09: ffff8cf2eb117700
[Fri Mar  8 13:01:32 2019] R10: ffff8cf2eb117788 R11: 0000000000000001 R12: ffff8cf2eacbb008
[Fri Mar  8 13:01:32 2019] R13: 0000000000000001 R14: dead000000000100 R15: ffffffffa9088170
[Fri Mar  8 13:01:32 2019] FS:  00007808b73ed740(0000) GS:ffff8cf2f6200000(0000) knlGS:0000000000000000
[Fri Mar  8 13:01:32 2019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Mar  8 13:01:32 2019] CR2: 0000000000000070 CR3: 0000000272cf8002 CR4: 00000000003606f0
[Fri Mar  8 13:01:32 2019] A link change request failed with some changes committed already. Interface lxcbr may have been left with an inconsistent configuration, please check.
[Fri Mar  8 13:01:33 2019] ath10k_pci 0000:3a:00.0: unsupported HTC service id: 1536
[Fri Mar  8 13:01:33 2019] DMAR: DRHD: handling fault status reg 2
[Fri Mar  8 13:01:33 2019] DMAR: [DMA Write] Request device [3a:00.0] fault addr 0 [fault reason 05] PTE Write access is not set
[Fri Mar  8 13:01:33 2019] A link change request failed with some changes committed already. Interface wlp58s0 may have been left with an inconsistent configuration, please check.
[Fri Mar  8 13:01:33 2019] ath10k_pci 0000:3a:00.0: unsupported HTC service id: 1536
[Fri Mar  8 13:01:33 2019] DMAR: DRHD: handling fault status reg 2
[Fri Mar  8 13:01:33 2019] DMAR: [DMA Write] Request device [3a:00.0] fault addr 0 [fault reason 05] PTE Write access is not set
[Fri Mar  8 13:01:39 2019] wlp58s0: authenticate with 04:f0:21:26:da:e4
[Fri Mar  8 13:01:39 2019] wlp58s0: send auth to 04:f0:21:26:da:e4 (try 1/3)
[Fri Mar  8 13:01:39 2019] wlp58s0: authenticated
[Fri Mar  8 13:01:39 2019] wlp58s0: associate with 04:f0:21:26:da:e4 (try 1/3)
[Fri Mar  8 13:01:39 2019] wlp58s0: RX AssocResp from 04:f0:21:26:da:e4 (capab=0x11 status=0 aid=2)
[Fri Mar  8 13:01:39 2019] wlp58s0: associated
[Fri Mar  8 13:01:39 2019] IPv6: ADDRCONF(NETDEV_CHANGE): wlp58s0: link becomes ready

--MP_/sdyjrug81+Sa3YFDakGoMTv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=kernel-config.txt

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86 5.0.0 Kernel Configuration
#

#
# Compiler: gcc (GCC) 8.3.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=80300
CONFIG_CLANG_VERSION=0
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION="-ARCH"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="xps"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_PSI=y
# CONFIG_PSI_DEFAULT_DISABLED is not set
CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
# CONFIG_MEMCG_SWAP_ENABLED is not set
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT_ALWAYS_ON=y
# CONFIG_USERFAULTFD is not set
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
# CONFIG_RSEQ is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
# CONFIG_PROFILING is not set
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_X86_X2APIC is not set
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
# CONFIG_X86_CPU_RESCTRL is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_HYPERVISOR_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_HYGON is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS_RANGE_BEGIN=2
CONFIG_NR_CPUS_RANGE_END=512
CONFIG_NR_CPUS_DEFAULT=64
CONFIG_NR_CPUS=4
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCELOG_LEGACY is not set
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_X86_VSYSCALL_EMULATION is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_X86_5LEVEL is not set
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
# CONFIG_X86_PMEM_LEGACY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_UMIP=y
# CONFIG_X86_INTEL_MPX is not set
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0x0
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_LEGACY_VSYSCALL_EMULATE is not set
CONFIG_LEGACY_VSYSCALL_NONE=y
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
# CONFIG_ACPI_SPCR_TABLE is not set
CONFIG_ACPI_LPIT=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_NFIT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_DPTF_POWER is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
# CONFIG_X86_SYSFB is not set

#
# Binary Emulations
#
# CONFIG_IA32_EMULATION is not set
# CONFIG_X86_X32 is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_HAVE_GENERIC_GUP=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
CONFIG_RESET_ATTACK_MITIGATION=y

#
# Tegra firmware driver
#
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST=y
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_HOTPLUG_SMT=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=32
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_ARCH_HAS_REFCOUNT=y
CONFIG_REFCOUNT_FULL=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y

#
# GCOV-based kernel profiling
#
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
CONFIG_GCC_PLUGIN_STRUCTLEAK=y
CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE is not set
CONFIG_GCC_PLUGIN_RANDSTRUCT=y
# CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE is not set
CONFIG_GCC_PLUGIN_STACKLEAK=y
CONFIG_STACKLEAK_TRACK_MIN_SIZE=100
# CONFIG_STACKLEAK_METRICS is not set
# CONFIG_STACKLEAK_RUNTIME_DISABLE is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
CONFIG_MODULE_SIG_HASH="sha512"
# CONFIG_MODULE_COMPRESS is not set
CONFIG_TRIM_UNUSED_KSYMS=y
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
CONFIG_BLK_WBT=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
# CONFIG_MQ_IOSCHED_DEADLINE is not set
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=m
CONFIG_BFQ_GROUP_IOSCHED=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_ZONE_DEVICE=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_FOU is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_INET_RAW_DIAG=y
CONFIG_INET_DIAG_DESTROY=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_NV is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_TCP_CONG_DCTCP is not set
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=y
# CONFIG_DEFAULT_CUBIC is not set
CONFIG_DEFAULT_BBR=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bbr"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_ESP_OFFLOAD is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
# CONFIG_IPV6_SEG6_LWTUNNEL is not set
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_ACCT is not set
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=m
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CONNTRACK_LABELS is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SNMP is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NF_CT_NETLINK=y
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_SET=y
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=y
CONFIG_NFT_COUNTER=y
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=y
CONFIG_NFT_LIMIT=y
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
# CONFIG_NFT_OBJREF is not set
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=y
CONFIG_NFT_REJECT_INET=y
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=y
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
CONFIG_NFT_OSF=m
# CONFIG_NFT_TPROXY is not set
# CONFIG_NF_DUP_NETDEV is not set
# CONFIG_NFT_DUP_NETDEV is not set
# CONFIG_NFT_FWD_NETDEV is not set
# CONFIG_NFT_FIB_NETDEV is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
# CONFIG_NETFILTER_XT_TARGET_HMARK is not set
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
CONFIG_NETFILTER_XT_NAT=m
# CONFIG_NETFILTER_XT_TARGET_NETMAP is not set
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_REDIRECT is not set
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
# CONFIG_NETFILTER_XT_MATCH_BPF is not set
# CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ECN is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_SOCKET_IPV4=m
# CONFIG_NF_TPROXY_IPV4 is not set
CONFIG_NF_TABLES_IPV4=y
# CONFIG_NFT_CHAIN_ROUTE_IPV4 is not set
CONFIG_NFT_REJECT_IPV4=y
# CONFIG_NFT_DUP_IPV4 is not set
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
# CONFIG_NF_DUP_IPV4 is not set
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=y
CONFIG_NF_NAT_IPV4=m
CONFIG_NF_NAT_MASQUERADE_IPV4=y
CONFIG_NFT_CHAIN_NAT_IPV4=m
CONFIG_NFT_MASQ_IPV4=m
CONFIG_NFT_REDIR_IPV4=m
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
# CONFIG_NF_TPROXY_IPV6 is not set
CONFIG_NF_TABLES_IPV6=y
# CONFIG_NFT_CHAIN_ROUTE_IPV6 is not set
CONFIG_NFT_REJECT_IPV6=y
# CONFIG_NFT_DUP_IPV6 is not set
CONFIG_NFT_FIB_IPV6=m
# CONFIG_NF_DUP_IPV6 is not set
CONFIG_NF_REJECT_IPV6=y
CONFIG_NF_LOG_IPV6=m
# CONFIG_NF_NAT_IPV6 is not set
# CONFIG_IP6_NF_IPTABLES is not set
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_TABLES_BRIDGE=y
CONFIG_NFT_BRIDGE_REJECT=m
CONFIG_NF_LOG_BRIDGE=m
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_MRP=m
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_6LOWPAN is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_SKBPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_CAKE=y
# CONFIG_NET_SCH_FQ is not set
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set
CONFIG_NET_SCH_DEFAULT=y
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_CLS_FLOWER is not set
# CONFIG_NET_CLS_MATCHALL is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_SAMPLE is not set
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
# CONFIG_NET_ACT_SIMP is not set
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_ACT_VLAN is not set
CONFIG_NET_ACT_BPF=y
# CONFIG_NET_ACT_SKBMOD is not set
# CONFIG_NET_ACT_IFE is not set
# CONFIG_NET_ACT_TUNNEL_KEY is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_MPLS is not set
# CONFIG_NET_NSH is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_BT=y
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_LEDS is not set
# CONFIG_BT_SELFTEST is not set

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTUSB_AUTOSUSPEND is not set
CONFIG_BT_HCIBTUSB_BCM=y
CONFIG_BT_HCIBTUSB_RTL=y
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_AG6XX is not set
# CONFIG_BT_HCIUART_MRVL is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
# CONFIG_CFG80211_REQUIRE_SIGNED_REGDB is not set
# CONFIG_CFG80211_REG_CELLULAR_HINTS is not set
CONFIG_CFG80211_REG_RELAX_NO_IR=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
# CONFIG_LWTUNNEL is not set
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
# CONFIG_FAILOVER is not set
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# PCI controller drivers
#

#
# Cadence PCIe controllers support
#
# CONFIG_VMD is not set

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_EXTRA_FIRMWARE="ath10k/QCA6174/hw3.0/firmware-6.bin ath10k/QCA6174/hw3.0/board-2.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
# CONFIG_FW_LOADER_USER_HELPER is not set
CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=y
CONFIG_BLK_DEV_NVME=y
# CONFIG_NVME_MULTIPATH is not set
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set

#
# Misc devices
#
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_MISC_RTSX=y
# CONFIG_PVPANIC is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC & related support
#

#
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# SCIF Bus Driver
#
# CONFIG_SCIF_BUS is not set

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#

#
# VOP Driver
#
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=y
# CONFIG_MISC_RTSX_USB is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_MOBILE_LPM_POLICY=0
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_CACHE is not set
# CONFIG_DM_WRITECACHE is not set
# CONFIG_DM_ERA is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=m
CONFIG_DM_VERITY_FEC=y
# CONFIG_DM_SWITCH is not set
# CONFIG_DM_LOG_WRITES is not set
CONFIG_DM_INTEGRITY=m
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=m
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_IFB is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_GENEVE is not set
# CONFIG_MACSEC is not set
# CONFIG_NETCONSOLE is not set
CONFIG_TUN=y
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_MDIO_DEVICE is not set
# CONFIG_PHYLIB is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_USB_NET_DRIVERS=m
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_RTL8152 is not set
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
CONFIG_USB_NET_CDC_SUBSET_ENABLE=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_VL600 is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_ATH_COMMON=y
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
CONFIG_ATH10K=y
CONFIG_ATH10K_CE=y
CONFIG_ATH10K_PCI=y
# CONFIG_ATH10K_SDIO is not set
# CONFIG_ATH10K_USB is not set
# CONFIG_ATH10K_DEBUG is not set
# CONFIG_ATH10K_DFS_CERTIFIED is not set
# CONFIG_WCN36XX is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
# CONFIG_WLAN_VENDOR_CISCO is not set
# CONFIG_WLAN_VENDOR_INTEL is not set
# CONFIG_WLAN_VENDOR_INTERSIL is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
# CONFIG_WLAN_VENDOR_REALTEK is not set
# CONFIG_WLAN_VENDOR_RSI is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
# CONFIG_WLAN_VENDOR_QUANTENNA is not set
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NET_FAILOVER is not set
# CONFIG_ISDN is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_SMBUS=y
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
CONFIG_RMI4_SMB=y
# CONFIG_RMI4_F03 is not set
# CONFIG_RMI4_F11 is not set
# CONFIG_RMI4_F12 is not set
# CONFIG_RMI4_F30 is not set
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_SERIO_OLPC_APSP is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVMEM is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
# CONFIG_SERIAL_8250_MOXA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_SCR24X is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
CONFIG_RANDOM_TRUST_CPU=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I3C is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ASPEED is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DELL_SMM is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_FTSTEUTATES is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_I5500 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6621 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MAX31790 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_OCC_P8_I2C is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83773G is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
CONFIG_INTEL_SOC_DTS_IOSF_CORE=y
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=y
CONFIG_ACPI_THERMAL_REL=y
CONFIG_INT3406_THERMAL=y
CONFIG_INTEL_PCH_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_CORE is not set
# CONFIG_WATCHDOG_NOWAYOUT is not set
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
# CONFIG_WATCHDOG_SYSFS is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_WDAT_WDT is not set
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_EBC_C384_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_INTEL_SOC_PMIC_CHTWC is not set
CONFIG_MFD_INTEL_LPSS=y
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS68470 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_RC_CORE is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=2
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
# CONFIG_DRM_DEBUG_MM is not set
# CONFIG_DRM_DEBUG_SELFTEST is not set
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_DP_CEC is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#

#
# AMD Library routines
#
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
# CONFIG_DRM_I915_CAPTURE_ERROR is not set
# CONFIG_DRM_I915_USERPTR is not set
# CONFIG_DRM_I915_GVT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# CONFIG_DRM_VGEM is not set
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# CONFIG_DRM_HISI_HIBMC is not set
# CONFIG_DRM_TINYDRM is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_PM8941_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=1024
CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
# CONFIG_SND_OSSEMUL is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_PROC_FS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SE6X is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_HDMI=y
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDA_CORE=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_PREALLOC_SIZE=2048
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SND_X86 is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACCUTOUCH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_ASUS is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_GT683R is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_ITE is not set
# CONFIG_HID_JABRA is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LED is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTI is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PENMOUNT is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEAM is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
# CONFIG_INTEL_ISH_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_LEDS_TRIGGER_USBPORT is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PLATFORM is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
CONFIG_TYPEC_TCPM=m
CONFIG_TYPEC_TCPCI=m
# CONFIG_TYPEC_RT1711H is not set
CONFIG_TYPEC_FUSB302=m
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
CONFIG_USB_ROLE_SWITCH=m
# CONFIG_USB_ROLES_INTEL_XHCI is not set
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_SDHCI_F_SDH30=m
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABX80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8010 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV8803 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_HSU_DMA=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_UDMABUF is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VFIO is not set
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_VIRTIO_MENU is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_R8822BE is not set
CONFIG_RTS5208=y
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_LTE_GDM724X is not set
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_GREYBUS is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_MTK_MMC is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# CONFIG_XIL_AXIS_FIFO is not set
# CONFIG_EROFS_FS is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACER_WIRELESS is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DCDBAS=y
CONFIG_DELL_SMBIOS=y
CONFIG_DELL_SMBIOS_WMI=y
CONFIG_DELL_SMBIOS_SMM=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_DESCRIPTOR=y
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_WMI_LED is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_DELL_RBTN is not set
# CONFIG_DELL_RBU is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_GPD_POCKET_FAN is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_LG_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=y
# CONFIG_WMI_BMOF is not set
# CONFIG_INTEL_WMI_THUNDERBOLT is not set
# CONFIG_MSI_WMI is not set
# CONFIG_PEAQ_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_HID_EVENT is not set
# CONFIG_INTEL_VBTN is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_INTEL_PMC_CORE is not set
# CONFIG_IBM_RTL is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_MXM_WMI is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_HUAWEI_WMI is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_IOVA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#

#
# Broadcom SoC drivers
#

#
# NXP/Freescale QorIQ SoC drivers
#

#
# i.MX SoC drivers
#

#
# Qualcomm SoC drivers
#
# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_ARM_GIC_MAX_NR=1
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_LIBNVDIMM is not set
# CONFIG_DAX is not set
CONFIG_NVMEM=y

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# CONFIG_FPGA is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_ENCRYPTION is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_ONLINE_SCRUB is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_FS_DAX is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
# CONFIG_MANDATORY_FILE_LOCKING is not set
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
CONFIG_OVERLAY_FS_INDEX=y
CONFIG_OVERLAY_FS_XINO_AUTO=y
CONFIG_OVERLAY_FS_METACOPY=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_EFIVAR_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEY_DH_OPERATIONS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY_FALLBACK is not set
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_INTEGRITY is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
# CONFIG_CRYPTO_DH is not set
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128L is not set
# CONFIG_CRYPTO_AEGIS256 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS128L_AESNI_SSE2 is not set
# CONFIG_CRYPTO_AEGIS256_AESNI_SSE2 is not set
# CONFIG_CRYPTO_MORUS640 is not set
# CONFIG_CRYPTO_MORUS640_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280 is not set
# CONFIG_CRYPTO_MORUS1280_SSE2 is not set
# CONFIG_CRYPTO_MORUS1280_AVX2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_OFB is not set
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_SM4 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
CONFIG_CRYPTO_ZSTD=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
# CONFIG_RAID6_PQ_BENCHMARK is not set
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_POISONING=y
CONFIG_PAGE_POISONING_NO_SANITY=y
CONFIG_PAGE_POISONING_ZERO=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_CC_HAS_KASAN_GENERIC=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=60
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_STACKTRACE=y
CONFIG_WARN_ALL_UNSEEDED_RANDOM=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_RCU_PERF_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
CONFIG_MEMTEST=y
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_X86_PTDUMP_CORE=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_EFI_PGT_DUMP is not set
CONFIG_DEBUG_WX=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set

--MP_/sdyjrug81+Sa3YFDakGoMTv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=bisect-log.txt

git bisect start
# good: [8fe28cb58bcb235034b64cbbb7550a8a43fd88be] Linux 4.20
git bisect good 8fe28cb58bcb235034b64cbbb7550a8a43fd88be
# bad: [1c163f4c7b3f621efff9b28a47abb36f7378d783] Linux 5.0
git bisect bad 1c163f4c7b3f621efff9b28a47abb36f7378d783
# good: [af7ddd8a627c62a835524b3f5b471edbbbcce025] Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping
git bisect good af7ddd8a627c62a835524b3f5b471edbbbcce025
# good: [c9bef4a651769927445900564781a9c99fdf6258] Merge tag 'pinctrl-v4.21-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good c9bef4a651769927445900564781a9c99fdf6258
# good: [4d5f6e0201bc568c0758ed3f77a06648ec9fd482] Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good 4d5f6e0201bc568c0758ed3f77a06648ec9fd482
# good: [680905431b9de8c7224b15b76b1826a1481cfeaf] Merge tag 'char-misc-5.0-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect good 680905431b9de8c7224b15b76b1826a1481cfeaf
# bad: [88fe73cb804abc3d209a06f6221a7108d89ff04f] Merge tag 'nfsd-5.0-2' of git://linux-nfs.org/~bfields/linux
git bisect bad 88fe73cb804abc3d209a06f6221a7108d89ff04f
# bad: [e5a8a1163211e2ab6f71c3545b26d55dc99ff1d3] Merge tag 'for-linus-20190209' of git://git.kernel.dk/linux-block
git bisect bad e5a8a1163211e2ab6f71c3545b26d55dc99ff1d3
# bad: [00670cb8a73b10b10d3c40f045c15411715e4465] net: dsa: Fix NULL checking in dsa_slave_set_eee()
git bisect bad 00670cb8a73b10b10d3c40f045c15411715e4465
# good: [9b1f19d810e92d6cdc68455fbc22d9f961a58ce1] dccp: fool proof ccid_hc_[rt]x_parse_options()
git bisect good 9b1f19d810e92d6cdc68455fbc22d9f961a58ce1
# good: [277aa590c3d552d01f9e62619707b2aa1a724566] Merge branch 'smc-fixes'
git bisect good 277aa590c3d552d01f9e62619707b2aa1a724566
# good: [c8101f7729daee251f4f6505f9d135ec08e1342f] net: dsa: Fix lockdep false positive splat
git bisect good c8101f7729daee251f4f6505f9d135ec08e1342f
# bad: [82eaa1fa0448da1852d7b80832e67e80a08dcc27] net/mlx5e: FPGA, fix Innova IPsec TX offload data path performance
git bisect bad 82eaa1fa0448da1852d7b80832e67e80a08dcc27
# bad: [f6ac8585897684374a19863fff21186a05805286] netfilter: nf_tables: unbind set in rule from commit path
git bisect bad f6ac8585897684374a19863fff21186a05805286
# good: [98bfc3414bda335dbd7fec58bde6266f991801d7] selftests: netfilter: add simple masq/redirect test cases
git bisect good 98bfc3414bda335dbd7fec58bde6266f991801d7
# good: [4e35c1cb9460240e983a01745b5f29fe3a4d8e39] netfilter: nf_nat: skip nat clash resolution for same-origin entries
git bisect good 4e35c1cb9460240e983a01745b5f29fe3a4d8e39
# first bad commit: [f6ac8585897684374a19863fff21186a05805286] netfilter: nf_tables: unbind set in rule from commit path

--MP_/sdyjrug81+Sa3YFDakGoMTv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=nftables.conf

#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority 0;policy drop;
                iif lo accept
                ct state vmap {
                        established: accept,
                        related:     accept,
                        untracked:   accept,
                        invalid:     drop
                }
                meta l4proto vmap {
                        icmp: accept,
                        icmpv6: accept,
                        tcp: jump tcp_input,
                        udp: jump udp_input
                }

                reject
        }
        chain tcp_input {
                tcp dport {  22, 22000, 8384,9090, 4001} accept
        }
        chain udp_input {
                iifname lxcbr udp dport 67 accept
                udp dport { 21027, 33445 } accept
        }
}

table ip nat {
        chain prerouting {
                type nat hook prerouting priority 0; policy accept;
        }
        chain postrouting {
                type nat hook postrouting priority 0; policy accept;
                oif "wlp58s0" ip saddr 10.64.32.0/24 masquerade
        }
}

--MP_/sdyjrug81+Sa3YFDakGoMTv--
