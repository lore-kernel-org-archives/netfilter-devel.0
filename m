From: Dash Four <mr.dash.four@googlemail.com>
Subject: Re: xtables-addons compile error (DNETMAP)
Date: Fri, 19 Apr 2013 16:22:21 +0100
Message-ID: <5171612D.9050506@googlemail.com>
References: <51707576.5010505@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60942 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030512Ab3DSPWd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:22:33 -0400
Received: by mail-we0-f174.google.com with SMTP id u12so3685507wey.5
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Apr 2013 08:22:31 -0700 (PDT)
In-Reply-To: <51707576.5010505@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Dash Four wrote:
> During build I get the following error:
>
> xt_DNETMAP.c: In function 'dnetmap_tg_check':
> xt_DNETMAP.c:331: error: incompatible types when assigning to type 
> 'kuid_t' from type 'unsigned int'
> xt_DNETMAP.c:332: error: incompatible types when assigning to type 
> 'kgid_t' from type 'unsigned int'
> xt_DNETMAP.c:344: error: incompatible types when assigning to type 
> 'kuid_t' from type 'unsigned int'
> xt_DNETMAP.c:345: error: incompatible types when assigning to type 
> 'kgid_t' from type 'unsigned int'
>
> The target kernel is 3.8.7. Any idea what could cause this?
The above error (and this is not confined to just DNETMAP) seems to be 
caused by CONFIG_UIDGID_STRICT_TYPE_CHECKS. When this is set, together 
with CONFIG_PROC_FS also being enabled in the kernel, the uid and gid 
fields of proc_dir_entry (proc_fs.h) are no longer "unsigned int", but a 
struct types, so they should be accessed/set with uid.val and gid.val 
instead - at least that is how I managed to get it work. I'll attach a 
patch if there is interest in fixing this bug - just let me know.
