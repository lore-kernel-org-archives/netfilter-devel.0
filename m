Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793364319;
	b=x9G6VtbP8B8Z07X7OHbKeivsnwL0bm5nbdlxEMGccUdQofEIcGO0I96y1ppwHEzq2GIt
	 5bcwyEecZUFUg2FdwZfIcK7j1cgo4wf7+rF/QkMm/T8KulVr4e0OX4rbsCFPCJwSAtaYT
	 4UVuptMJOuEE8CtlZw6RxcNQRUc9WvyIf32jMl/X8Z+UMOVovc/wl/qLFx6FAVt+jgOz3
	 xbXDeqonBoOEB3KNBypwShPt70qVTPhGvIthR6HMgAeVx0Et6v1ZKrSbwrGcevcmTZ203
	 lbIJxr5mvnlSxLTLNP7R5Q8xdU2yMcnqihZn8jkgosKq8TxV+i/1um30xnegxzVrAdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793364319;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:Reply-To:
	 References:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=i2Z/CznOqG6pFYhzOsFIrCyvpbPR5tUkk34BwQYFObw=;
	b=Q3xgJlp2+4pHb9eEZ1QPnhhu6d1N62YLYB8Fo/O0tMaWqzCZIBsEO/FJy0j/SNuhY4qs
	 LAS+5AWJzVRtS/79zRHQh/39sv2no+xg87SY54NaB/ualYn89Td1hNIzZz/MX5BQTRuHC
	 Z6QKf1ZzlnXciGBO1O9eb/IY9gAAejabdAgV4nnaADmFvMjmK0DhMsZZ/WsYhuAlSVK3H
	 zGndhSOQqddJLbGd6o4NO0pwyAzxBrmxGMgJKVteFQnJWS9e15wG/zEKu7+cVMaOLf6eA
	 469Oy68LSqiThz5BjciTBPpi+dEuoF/kw1tIirg5V6bEyWhakvNyJkgCadSY0+mg1QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0HhTUGzb;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1894606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 12:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1894606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0HhTUGzb
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so5522325e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 05:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793364317; x=1793969117; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:reply-to:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i2Z/CznOqG6pFYhzOsFIrCyvpbPR5tUkk34BwQYFObw=;
        b=0HhTUGzbDcque46HCGS3FsP6ZrwP+ILNkUoLfhJk4lPddViUUzr3eqDiv5b9BtawvD
         zb8zYiBl8G5kBR7wgMJDslVOzKdJouTG1hUoHhVDIQbnCbKk3rzCk05Gf0KdlBDr+R1Z
         PF8EIJnGinjk9LMEies+NPSegvcB0GHt3W0rkOHAfempTNoh71xsI7FWp04nOXHtpEKA
         Jld1hUrGGzUfCwJ2P9KCg8AdRkqfH/mWz+sdVc1EcMgveyTV6jUF6FGjJBwH8xJAcHhG
         EEniy5jFmKr1tHG4rJhEl3e0Ffk4BmD0OjG9gZmvPCB3YE7eSw4n2Dg9vVB6N/x6gw10
         l64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793364317; x=1793969117;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:reply-to:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i2Z/CznOqG6pFYhzOsFIrCyvpbPR5tUkk34BwQYFObw=;
        b=Gi8oLHi15JNKWbnIw4F+LHTHcwmLR3Ba0xKssK8T3sMRNV9T6Knvy862Wo4f2CxMVz
         NIn7GqOVX2IovI1DMcGJ4gXB7WSAXK8mvfK66+AcqYCOf41Qfr8uSQhqiFFYq2k67Eab
         UFv0f0emy4cYgl9QodRMVP4mKCQhXeGvTKIKdkPKKJnCPGQJyMCjYSQM7UswqCt+0+Ma
         cRisPAYmPn0iS1tPsx3FUYnqSaoIh8FsH3Xhi4YcVGhvDXZ4CgfjcX0ahZNKkO0QW580
         3xriW+OVC99gInXjPOeW7YmI+tI3RY6CYVzaGkDiwl4NHkI9s4U2wHJHTsdnKf368TbF
         xBbw==
X-Forwarded-Encrypted: i=1; AKwUvBxnPJR1pUAuovSN7qXqHjgnc+VxrRslgfuAs87UfrYHF0XFO7nMtca0X+qtXI3Ut+joR3ursUAAEpyWghcBo0c=@vger.kernel.org
X-Gm-Message-State: AFq9FYLai7PAO2fTJKf+y1PacyYjShuQMeyLs/HM42pr8KZ0syf8+9l2
	MWk6z/mpLYP1GzpD/ayq9Y8xMB1KQa8+5ChcmC6R1g7OW8Zqy4Sbg5bhRxeIppZw
X-Gm-Gg: AYBFou1NQwq7C+OA85PiO+7hM6CR1PlMETR+++/kenLLfa7VPr1DKhpVV21QPo6Vp5E
	Q+ysC+pDe5KABwgoutNqViyfCSPamSBVCjkX5aNIQyjoi0MxUuAzuYLlmdlfpnqBvoYAAF58/62
	iSuA8d8pRLErR9SYjTSBbeIxbO9f/tBDYkezwJ6iJoQ61WW6ORZ4Jg8NB67tNYSh3TBZYAfeT7l
	G8unK8GGUixTarSQDhWaOLPYr+5IZTPUTxBC8lRHmwwuOrfXCjX7Ok45LXxOpDQmwAs6DnNQJ6J
	6yiCwqDr5P2t/OH7h2C3kRQfjWZW0IBS4vZoFLv7q/zYOk9A3EM6T2AdTshTY+CRsCcoMsxS8bY
	/5JLlCRTKvvOfo6V1YjJnIphvi2dcPoJY4FoDVrDY2xjbZbqx3h8Iufig2nIObwosm4fZdlgH8h
	9nl+EgGo9fmkI63q0JV0fhuea24gvGBdjPg3W9HWCLHMitnQuhzf/ApxN6QLbIz0zdtk5tMZxOn
	/091IDa322nTpyLmawYS4Mu7lcuzzTYh9eJ9g9F26VCIsIQSDEqDi5Em2Ip91FNlz/zRWAbYWeq
	EjncUoROf6I213fE4HuOMb7/kuYDPe/pzDmDHTtAoYRaRFPdtjTOfacs5CK6xXMKx80e/yB0n7v
	nnQ8Dq0O1GgiSdA==
X-Received: by 2002:a05:600c:468b:b0:4a1:e225:b122 with SMTP id 5b1f17b1804b1-4ac182dcb7amr46400415e9.14.1793364316819;
        Fri, 30 Oct 2026 05:45:16 -0700 (PDT)
Received: from ?IPV6:2a01:cb15:86cb:1100:1bc3:2226:ceb4:c3c8? ([2a01:cb15:86cb:1100:1bc3:2226:ceb4:c3c8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04723sm154020545e9.5.2026.10.30.05.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 05:45:16 -0700 (PDT)
Message-ID: <7732fc2d-bdda-48fa-8822-b8066e22687b@gmail.com>
Date: Fri, 30 Oct 2026 13:45:15 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1149525: invalid pointer in nf_conntrack
From: Philip Dodd <orange.spyderman@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 1149525@bugs.debian.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org
Reply-To: Philip Dodd <orange.spyderman@gmail.com>, 1149525@bugs.debian.org
References: <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <59d64272-e162-486c-99c2-6f61feead01b@gmail.com> <auDhy6OW5SrGg3jv@monoceros>
 <auMgBQDEedGU8iiT@strlen.de>
 <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <e80f4fde-ec36-4fc3-9386-7b8c1053e1bf@gmail.com> <auRJp3wtNw4yaWXK@monoceros>
 <0d043989-c4b6-424a-93a8-3165e38750ad@gmail.com>
 <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <2256eafc-a76e-4b6f-b90e-1f5ed7147752@gmail.com>
Content-Language: en-GB
In-Reply-To: <2256eafc-a76e-4b6f-b90e-1f5ed7147752@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 30/10/2026 10:56, Philip Dodd wrote:
>
> On 30/10/2026 09:03, Philip Dodd wrote:
>>
>> On 30/10/2026 08:45, Uwe Kleine-König wrote:
>>> Hello Philip,
>>>
>>> On Fri, Oct 30, 2026 at 08:00:31AM +0100, Philip Dodd wrote:
>>>> On 29/10/2026 11:29, Florian Westphal wrote:
>>>>> Uwe Kleine-König <ukleinek@debian.org> wrote:
>>>>>> this is about a bug report filed against the Debian 7.2.12 
>>>>>> kernel. Further
>>>>>> context can be found at https://bugs.debian.org/1149525.
>>>>>>
>>>>>> Note this is an arm64 machine, and the problem doesn't reproduce 
>>>>>> on 7.3.
>>>>>>
>>>>>> On Mon, Oct 26, 2026 at 08:36:01AM +0100, Philip Dodd wrote:
>>>>>>> 7.2.12+deb14-arm64 is affected in the same way, reproduced by 
>>>>>>> just loading
>>>>>>> the nf_conntrack module shortly after boot.
>>>>>>>
>>>>>>> After the failure:
>>>>>>>       nf_conntrack module use count: 0
>>>>>>>       net.netfilter.nf_conntrack_count: 0
>>>>>>>       nf_conntrack hashsize: 65536
>>>>>>>       /proc/sys/kernel/tainted: 128
>>>>>>>
>>>>>>> No nf_nat or xt_* modules were loaded.
>>>>> If thats the case, why is there a conntrack entry in the first place?
>>>>> Is 'enable_hooks' modparam used?
>>>> No, I'm not explicitly using |enable_hooks|. Simply running |sudo 
>>>> modprobe
>>>> nf_conntrack|is sufficient to trigger the oops.
>>>>
>>>> For context, I originally encountered the oops shortly after boot 
>>>> during
>>>> normal operation. I narrowed it down to occurring shortly after
>>>> |tailscaled|started, but subsequently found that even with Tailscale
>>>> disabled, simply loading |nf_conntrack|triggers the same oops almost
>>>> immediately; and since I've reproduced this on all the 7.2.x 
>>>> kernels I've
>>>> tested (the versions mentioned earlier in the Debian bug report), 
>>>> but also
>>>> kernels compiled directly from upstream sources.
>>>>
>>>> The same |modprobe nf_conntrack|command does not trigger the oops 
>>>> on 7.1.x
>>>> or 7.3.x kernels; Prior to upgrading to the first 7.2.x kernel, 
>>>> this host
>>>> had also been running Tailscale with |nf_conntrack|loaded for weeks 
>>>> (at
>>>> least) without any problems and yesterday, I installed the 7.3.x 
>>>> kernel
>>>> packages from Debian experimental and ran Tailscale for an extended 
>>>> period
>>>> without encountering any issues.
>>> Given that you know how to compile kernels for your machine, can you
>>> please test plain 7.2? Depending on that being good or bad, I'd ask you
>>> to do a bisection either between 7.2 and 7.2.12 (to find the breaking
>>> commit) or between 7.2 and 7.3 (to find the fixing commit). If you
>>> report the state of 7.2, I can prepare more detailed instruction for 
>>> the
>>> bisect if needed.
>>
>> This has already been done against upstream 7.2.9, and it showed the 
>> same behaviour - full boot log attached, oops here.  I will need 
>> hand-holding on the bisect :(
>>
>> [   27.360619] Unable to handle kernel paging request at virtual 
>> address 0000000000010037
>> [   27.361311] Mem abort info:
>> [   27.396553]   ESR = 0x0000000096000006
>> [   27.397033]   EC = 0x25: DABT (current EL), IL = 32 bits
>> [   27.397350]   SET = 0, FnV = 0
>> [   27.408598]   EA = 0, S1PTW = 0
>> [   27.416453]   FSC = 0x06: level 2 translation fault
>> [   27.423827] Data abort info:
>> [   27.433403]   ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
>> [   27.440877]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>> [   27.447162]   GCS = 0, Overlay = 0, DirtyBit = 0
>> [   27.453819] user pgtable: 4k pages, 48-bit VAs, pgdp=000000003077f000
>> [   27.461191] [0000000000010037] pgd=08000000422ce403, 
>> p4d=08000000422ce403, pud=0800000020318403, pmd=0000000000000000
>> [   27.468753] Internal error: Oops: 0000000096000006 [#1]  SMP
>> [   27.475765] Modules linked in: xt_connmark xt_conntrack 
>> xt_MASQUERADE xt_tcpudp xt_mark nft_compat x_tables nft_chain_nat 
>> nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 tun 
>> snd_soc_hdmi_codec dw_hdmi_cec dw_hdmi_i2s_audio snd_soc_spdif_tx 
>> snd_soc_audio_graph_card panfrost gpu_sched snd_soc_simple_card 
>> drm_shmem_helper snd_soc_simple_card_utils leds_gpio gpio_ir_recv 
>> snd_soc_rockchip_i2s hci_uart hantro_vpu rockchip_vdec btqca 
>> binfmt_misc btrtl v4l2_jpeg v4l2_vp9 btintel btbcm btsdio rockchipdrm 
>> rockchip_rga bluetooth v4l2_h264 snd_soc_es8316 videobuf2_dma_contig 
>> v4l2_mem2mem snd_soc_core dw_hdmi_qp realtek videobuf2_dma_sg 
>> brcmfmac_wcc dw_mipi_dsi phy_package videobuf2_memops videobuf2_v4l2 
>> dw_hdmi videodev analogix_dp snd_compress snd_pcm_dmaengine 
>> drm_dp_aux_bus ofpart snd_pcm ecdh_generic drm_display_helper 
>> videobuf2_common snd_timer mc cec dwmac_rk spi_nor stmmac_platform 
>> brcmfmac rc_core mtd snd drm_client_lib stmmac drm_dma_helper 
>> brcmutil soundcore drm_kms_helper pcs_xpcs phylink coresight_cpu_debug
>> [   27.483382]  rockchip_thermal coresight_etm4x rockchip_saradc 
>> industrialio_triggered_buffer coresight kfifo_buf industrialio 
>> cpufreq_dt evdev cfg80211 rfkill nf_tables dm_mod efi_pstore configfs 
>> ext4 crc16 mbcache jbd2 xhci_plat_hcd xhci_hcd fusb302 tcpm dwc3 
>> aux_hpd_bridge rk808_regulator reset_gpio udc_core drm ulpi typec 
>> fan53555 ghash_ce dwc3_of_simple pwm_regulator gf128mul gpio_rockchip 
>> pwm_fan fixed ohci_platform gpio_keys ehci_platform ehci_hcd 
>> phy_rockchip_pcie ohci_hcd nvmem_rockchip_efuse phy_rockchip_typec 
>> phy_rockchip_inno_usb2 phy_rockchip_emmc usbcore dw_wdt pl330 
>> io_domain sdhci_of_arasan sdhci_pltfm pwm_rockchip rockchip_dfi 
>> usb_common spi_rockchip dw_mmc_rockchip sdhci i2c_rk3x dw_mmc_pltfm 
>> dw_mmc cqhci autofs4 aes_ce_blk aes_neon_bs
>> [   27.483775] CPU: 4 UID: 0 PID: 86 Comm: kworker/4:3 Not tainted 
>> 7.2.9-rockpro-gcc15 #1local1 PREEMPTLAZY
>> [   27.483955] Hardware name: Pine64 RockPro64 v2.1 (DT)
>> [   27.484589] Workqueue: events_power_efficient gc_worker 
>> [nf_conntrack]
>> [   27.484858] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS 
>> BTYPE=--)
>> [   27.485073] pc : gc_worker+0x134/0x780 [nf_conntrack]
>> [   27.485282] lr : process_one_work+0x17c/0x500
>> [   27.485490] sp : ffff800080babd30
>> [   27.485668] x29: ffff800080babd30 x28: 0000000000005161 x27: 
>> ffffd79995e16a00
>> [   27.485895] x26: 000000000000007f x25: 0000000000000000 x24: 
>> 0000000000010000
>> [   27.486127] x23: 00000000000124f7 x22: ffff00000e885a00 x21: 
>> 000000000000be70
>> [   27.486315] x20: ffffd7998e0bb968 x19: ffffd7998e0bee08 x18: 
>> 0000000000000004
>> [   27.486535] x17: ffff286761a25000 x16: ffff800080020000 x15: 
>> ffffd79995e22218
>> [   27.486740] x14: 0000000000000000 x13: 0000000000000030 x12: 
>> 0101010101010101
>> [   27.486937] x11: 00000000fffef5c0 x10: feff736d64686268 x9 : 
>> 0000000000000038
>> [   27.487143] x8 : 8080000000000000 x7 : ffffd79995e16000 x6 : 
>> fefefefefefefeff
>> [   27.487363] x5 : ffff0000059b2508 x4 : ffffd7998e0bb970 x3 : 
>> 0000000000010000
>> [   27.487552] x2 : fffffffffffffff0 x1 : 0000000000000000 x0 : 
>> 0000000000000000
>> [   27.487744] Call trace:
>> [   27.487965]  gc_worker+0x134/0x780 [nf_conntrack] (P)
>> [   27.488240]  process_one_work+0x17c/0x500
>> [   27.488445]  worker_thread+0x18c/0x310
>> [   27.488635]  kthread+0x134/0x150
>> [   27.488808]  ret_from_fork+0x10/0x20
>> [   27.488978] Code: f94042c0 37180300 f9400318 37001438 (3940df00)
>> [   27.489801] ---[ end trace 0000000000000000 ]---
>> [   27.514367] note: kworker/4:3[86] exited with preempt_count 1
>>
> I have just booted into a package from a vanilla 7.2.0 and it does not 
> oops either by loading the module with modprobe nf_conntrack or by 
> starting tailscale and doing "real" work...  So somewhere between 
> 7.2.0 and 7.2.9, something broke.
>>
OK - it's more complicated than that - previously Oops'ing images now no 
longer Oops either, so something else has changed.  Am investigating but 
am pausing any bisect work until I can reliably reproduce the issue 
again. Having gone for a couple of weeks of being able to reproduce it 
easily, I now can't.

Apologies for that

>>>
>>> Thanks
>>> Uwe
>
