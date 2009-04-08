From: Tim Verhoeven <tim.verhoeven.be@gmail.com>
Subject: Re: Compiling ebtables statically or dynamically results in different
	behaviour
Date: Wed, 8 Apr 2009 11:57:38 +0200
Message-ID: <2a7fce340904080257r4164cd63hcd5f07b036489aae@mail.gmail.com>
References: <W8403423488155181239184148@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "bdschuym@pandora.be" <bdschuym@telenet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:40467 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbZDHJ5l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:57:41 -0400
Received: by bwz17 with SMTP id 17so38600bwz.37
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Apr 2009 02:57:38 -0700 (PDT)
In-Reply-To: <W8403423488155181239184148@nocme1bl6.telenet-ops.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 8, 2009 at 11:49 AM, bdschuym@pandora.be
<bdschuym@telenet.be> wrote:
> What is your exact command and what type of processor are you using?
>

The command run is "ebtables -N 1000"

This is /proc/cpuinfo :
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Xeon(R) CPU           E5430  @ 2.66GHz
stepping        : 6
cpu MHz         : 2666.758
cache size      : 6144 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu tsc msr pae mce cx8 apic mtrr mca cmov pat pse36
clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc
pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips        : 6669.91
clflush size    : 64
cache_alignment : 64
address sizes   : 38 bits physical, 48 bits virtual

It's a standard Intel Xeon (the server is a IBM HS21 Blade).

Regards,
Tim

-- 
Tim Verhoeven - tim.verhoeven.be@gmail.com - 0479 / 88 11 83

Hoping the problem  magically goes away  by ignoring it is the
"microsoft approach to programming" and should never be allowed.
(Linus Torvalds)
