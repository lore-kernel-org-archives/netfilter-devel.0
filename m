Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADC1C04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 17:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0EC42089E
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 17:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfFFR6b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 13:58:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55247 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfFFR6b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 13:58:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so817083wme.4
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2019 10:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PLhhQ7wNkPLJns0o9nBdhSH+T9DfxChPAWXwZWgUaxU=;
        b=aL9TciwLnGPtlTEnHy6bjC6rYbItRzzBE5vDKHYhiFHMoy37r1S9RZ4B/w0ib1QUx6
         kmbCdY2rV5sOXANyfaLESh9mMh2gSZHHcO1MNunbGcWyFrUJqGtZSgCV1QgdA+TBW6GY
         rJw05dFF/+762yHlBTe/ZsRrMOSlt7Hz5mcdMmguhJDW/wWaycDyOgoGx0OHF7aiDR7p
         4iA16wzaASUcbY9YtjHxu5LDuzjpr7iFt1F5rd+977i4vDfZaGpU/0ANyXC2cEJOyeK2
         X4Fp70eC3A+RLAK9Div5qgdcRBBDOWTpfFGWx8bLbLRgHFeanDX4hTwn07emg6pkXjDK
         VjjQ==
X-Gm-Message-State: APjAAAUuhFJyQlGpp1YzZvlZYnBY7TUvMWTbocDGckant6fKQOE5+lNb
        ObN+1mOZ/vAtFz9JJyGlAdY2ZH2tS80=
X-Google-Smtp-Source: APXvYqwC+jcgZrz0DJOD/GvXtvjmUGW2KVS25rgMEXTKDwT0sCw9HFd+TjysEQJ9DPh1Ve7XnJY6ig==
X-Received: by 2002:a1c:f314:: with SMTP id q20mr791858wmq.74.1559843909100;
        Thu, 06 Jun 2019 10:58:29 -0700 (PDT)
Received: from linux.home (2a01cb058382ea004233e954b48ed30d.ipv6.abo.wanadoo.fr. [2a01:cb05:8382:ea00:4233:e954:b48e:d30d])
        by smtp.gmail.com with ESMTPSA id c11sm2591239wrs.97.2019.06.06.10.58.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 10:58:28 -0700 (PDT)
Date:   Thu, 6 Jun 2019 19:58:26 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Peter Oskolkov <posk@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipv6: nf_defrag: accept duplicate
 fragments again
Message-ID: <20190606175826.GA3683@linux.home>
References: <e8f3e725c5546df221c4aeec340b6bb73631145e.1559836971.git.gnault@redhat.com>
 <20190606162930.yxcuk3nsrath7qxq@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606162930.yxcuk3nsrath7qxq@breakpoint.cc>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 06, 2019 at 06:29:30PM +0200, Florian Westphal wrote:
> Guillaume Nault <gnault@redhat.com> wrote:
> > When fixing the skb leak introduced by the conversion to rbtree, I
> > forgot about the special case of duplicate fragments. The condition
> > under the 'insert_error' label isn't effective anymore as
> > nf_ct_frg6_gather() doesn't override the returned value anymore. So
> > duplicate fragments now get NF_DROP verdict.
> > 
> > To accept duplicate fragments again, handle them specially as soon as
> > inet_frag_queue_insert() reports them. Return -EINPROGRESS which will
> > translate to NF_STOLEN verdict, like any accepted fragment. However,
> > such packets don't carry any new information and aren't queued, so we
> > just drop them immediately.
> 
> Why is this patch needed?
> 
> Whats the difference between
> 
> NF_DROP and kfree_skb+NF_STOLEN?
> 
> AFAICS this patch isn't needed, as nothing is broken, what am I missing?
> 
If the fragment was generated locally, then NF_DROP propagates the EPERM
error back to the sender, which breaks the ip_defrag selftest.
