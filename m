Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B9EC64E90
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 00:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB53A20757
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 00:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgLBAtj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 19:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgLBAti (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 19:49:38 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E0CC0613D6
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Dec 2020 16:48:58 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id e13so113550pfj.3
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Dec 2020 16:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/fKv5F3ku6dAz8MDwjdtM8xp8kuRZkZb5KHj4LO7twk=;
        b=JjxyvsIhCZGCexZjHjW3/q4SZm2S1po42f5rWBYNZpknOcEv/4ukHAd7dYoOcLbu08
         v9lir0vGgCrDfr3g4PJPmBdnSX9AtilLwAKcoLMpetkmp8Bhe+z4QXdSRWLcWS0Tqf70
         Xl3eKVOJ2k93ikHIJdW1ZLWQ5nevzaKciUV1A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/fKv5F3ku6dAz8MDwjdtM8xp8kuRZkZb5KHj4LO7twk=;
        b=L7CmgaKpD880NBoni2KFsY7f7ZcviSzJ73cC3IPALMewPN3o2rr7xNcTea9z586xJx
         d+i6nSPTpYfFPAzcAFBWaXsFmbclE7kgWaNq/ueUTSeuc4u59mMqxIrQYhs4G+SxB8XZ
         LwsUXAXkCrS1HhsiMthmxhx2aNifDPOxwut6CuJwt9+KMfK6rHA/uuBw04LrJw1Viulb
         9IkI3IHtCUqmS8EQLyJHGc/o004cbFsR4uRpoNtXmYml7re0AufIGRzJh/CxHho5DwTb
         fWdL0PnaQLVdE+WdSeHsC+0HywxwOynmqnm7Th1MfzOaS2NaxxUT9+Kk3aWCAit8W9Ky
         6Tqg==
X-Gm-Message-State: AOAM532q7FX8mHP8K4zyiD81bDH92v16HtHRcakGguLDnqKR7kg8fLNx
        NdB+Ybm/O9jjlqGYoIK4GSe+fw==
X-Google-Smtp-Source: ABdhPJxPo4FcPctt9GYJiUhuxfJKkE2jzZbWtQgZ4zmCr6jeE52ztB/bGQ6fwSzhNexVjYTI2+X2Vw==
X-Received: by 2002:a62:78d3:0:b029:198:ad8:7d05 with SMTP id t202-20020a6278d30000b02901980ad87d05mr90210pfc.18.1606870137646;
        Tue, 01 Dec 2020 16:48:57 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f5sm83328pgg.74.2020.12.01.16.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 16:48:56 -0800 (PST)
Date:   Tue, 1 Dec 2020 16:48:55 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Cc:     akpm@linux-foundation.org, bp@alien8.de, coreteam@netfilter.org,
        syzbot <syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com>,
        davem@davemloft.net, gustavoars@kernel.org, hpa@zytor.com,
        john.stultz@linaro.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        wang.yi59@zte.com.cn, x86@kernel.org
Subject: Re: UBSAN: array-index-out-of-bounds in arch_uprobe_analyze_insn
Message-ID: <202012011616.DFBE3FC5BC@keescook>
References: <00000000000082559e05afc6b97a@google.com>
 <0000000000002cd54805afdf483f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002cd54805afdf483f@google.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

There appears to be a problem with prefix counting for the instruction
decoder. It looks like insn_get_prefixes() isn't keeping "nb" and "nbytes"
in sync correctly:

        while (inat_is_legacy_prefix(attr)) {
                /* Skip if same prefix */
                for (i = 0; i < nb; i++)
                        if (prefixes->bytes[i] == b)
                                goto found;
                if (nb == 4)
                        /* Invalid instruction */
                        break;
                prefixes->bytes[nb++] = b;
		...
found:
                prefixes->nbytes++;
                insn->next_byte++;
                lb = b;
                b = peek_next(insn_byte_t, insn);
                attr = inat_get_opcode_attribute(b);
        }

(nbytes is incremented on repeated prefixes, but "nb" isn't)

However, it looks like nbytes is used as an offset:

static inline int insn_offset_rex_prefix(struct insn *insn)
{
        return insn->prefixes.nbytes;
}
static inline int insn_offset_vex_prefix(struct insn *insn)
{
        return insn_offset_rex_prefix(insn) + insn->rex_prefix.nbytes;
}

Which means everything that iterates over prefixes.bytes[] is buggy,
since they may be trying to read past the end of the array:

$ git grep -A3 -E '< .*prefixes(\.|->)nbytes'
boot/compressed/sev-es.c:       for (i = 0; i < insn->prefixes.nbytes; i++) {
boot/compressed/sev-es.c-               insn_byte_t p =
insn->prefixes.bytes[i];
boot/compressed/sev-es.c-
boot/compressed/sev-es.c-               if (p == 0xf2 || p == 0xf3)
--
kernel/uprobes.c:       for (i = 0; i < insn->prefixes.nbytes; i++) {
kernel/uprobes.c-               insn_attr_t attr;
kernel/uprobes.c-
kernel/uprobes.c-               attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
--
kernel/uprobes.c:       for (i = 0; i < insn->prefixes.nbytes; i++) {
kernel/uprobes.c-               if (insn->prefixes.bytes[i] == 0x66)
kernel/uprobes.c-                       return -ENOTSUPP;
kernel/uprobes.c-       }
--
lib/insn-eval.c:        for (i = 0; i < insn->prefixes.nbytes; i++) {
lib/insn-eval.c-                insn_byte_t p = insn->prefixes.bytes[i];
lib/insn-eval.c-
lib/insn-eval.c-                if (p == 0xf2 || p == 0xf3)
--
lib/insn-eval.c:        for (i = 0; i < insn->prefixes.nbytes; i++) {
lib/insn-eval.c-                insn_attr_t attr;
lib/insn-eval.c-
lib/insn-eval.c-                attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);

I don't see a clear way to fix this.

-Kees

On Mon, Sep 21, 2020 at 09:20:07PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 4b2bd5fec007a4fd3fc82474b9199af25013de4c
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Sat Oct 8 00:02:33 2016 +0000
> 
>     proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1697348d900000
> start commit:   325d0eab Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1597348d900000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1197348d900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b12e84189082991c
> dashboard link: https://syzkaller.appspot.com/bug?extid=9b64b619f10f19d19a7c
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1573a8ad900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=164ee6c5900000
> 
> Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
> Fixes: 4b2bd5fec007 ("proc: fix timerslack_ns CAP_SYS_NICE check when adjusting self")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

-- 
Kees Cook
