From: Hyunseok <hyunseok@ieee.org>
Subject: Finding the PID of a process from sk_buff
Date: Fri, 18 Aug 2017 14:19:19 -0400
Message-ID: <CAAJNysJa+Pyggh6F0gYe2CqfT1gPLk50vqqVfgGnpniD51dtMw@mail.gmail.com>
Reply-To: hyunseok@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34227 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbdHRSTU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2017 14:19:20 -0400
Received: by mail-io0-f175.google.com with SMTP id o9so35834435iod.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2017 11:19:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am capturing locally generated sk_buffs from local_out netfilter hook.

Inside this local_out hook, is there a way to find the PID of a
userspace process that has generated sk_buff?

skb->sk->socket->file->f_owner->pid seems to be NULL.

current->pid does not reliably tell the correct userspace process either.

Is there any other way?  Any help is much appreciated.

-hs
