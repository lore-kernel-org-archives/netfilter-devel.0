Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B27EB64DD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jul 2023 14:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjGUODW convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jul 2023 10:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjGUODV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jul 2023 10:03:21 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134DE2737
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jul 2023 07:03:12 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-31438512cafso1668336f8f.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jul 2023 07:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689948190; x=1690552990;
        h=content-transfer-encoding:mime-version:organization:user-agent
         :message-id:in-reply-to:references:from:subject:cc:to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vceOqaktkiSE2cQE0zExZEjVbdIAaq15Y6qyBTUcBb0=;
        b=hk6QlfZXUDTxVco9mPEpAAjOySC2BrFy8T0E2idtY/4ja88ZO1Ss8e8MHAjpwKhVQq
         QEwhaZ+6vDd7UgDWvCf49EWtToZi+QDzCqZbad8aalhdDnj6mzvHfAiJaaZOBnJZVSLt
         EvkQ1v5Q7N/mphYl7ozocpKzdmZ4xYzOdrtFshNGoDfuRfYzm82wJWyh9ZmWhtYqg39P
         yPoR2GoEsPTe+XjOe2p1ryfj+3jg6/PTPfLsrzsR2C4kXnwXgwUSKaKaHFZfB9Rt5x55
         x83+GPMASA37URZmo2taigeYTcSCXSj/cuRjKgqPxEtqmUiHtiaAKK/Zk2mlg85O/Yc+
         B3eg==
X-Gm-Message-State: ABy/qLbgQ/hlMNZibVLsBss48mhvKX7XdbHWt626UyeXgbc7KGR/SW8h
        f/+WaSFEOWA6dPzsrFxr7pE2Pz8dHXOYfg==
X-Google-Smtp-Source: APBJJlHXrBttoLrl3z2stqnAJqyodJ5JjZ7tIjjiBaX1vqDmD6WdvP8bYYpZ555qQfA1VXNTgvyFBg==
X-Received: by 2002:adf:f592:0:b0:314:13e2:2f6c with SMTP id f18-20020adff592000000b0031413e22f6cmr1517995wro.58.1689948190082;
        Fri, 21 Jul 2023 07:03:10 -0700 (PDT)
Received: from rhea.home.vuxu.org ([94.45.237.107])
        by smtp.gmail.com with ESMTPSA id z24-20020aa7c658000000b0051e166f342asm2143566edr.66.2023.07.21.07.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 07:03:09 -0700 (PDT)
Received: from localhost (rhea.home.vuxu.org [local])
        by rhea.home.vuxu.org (OpenSMTPD) with ESMTPA id 7437705a;
        Fri, 21 Jul 2023 14:03:07 +0000 (UTC)
Date:   Fri, 21 Jul 2023 16:03:07 +0200
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     arturo@netfilter.org, netfilter-devel@vger.kernel.org,
        Jan Engelhardt <jengelh@inai.de>, phil@nwl.cc
Subject: Re: [ANNOUNCE] nftables 1.0.8 release
From:   Leah Neukirchen <leah@vuxu.org>
References: <cc7b9429-540e-967d-1c50-7475b28a0973@netfilter.org>
 <87351i8unw.fsf@vuxu.org> <ZLqL1g6YAbNOloRN@calendula>
In-Reply-To: <ZLqL1g6YAbNOloRN@calendula>
Message-Id: <3JB4V2Y9XMB3V.2LVU7NM8H08ZO@rhea.home.vuxu.org>
User-Agent: mblaze/1.2-20-g23a9e70-dirty (2023-07-18)
Organization: vuxu.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
> 
> Thanks for your patch.
> 
> On Thu, Jul 20, 2023 at 05:33:23PM +0200, Leah Neukirchen wrote:
> > For Void Linux, I have applied this fix, which results in installing
> > the same way was for 1.0.7 (else it creates a .egg directory which isn't
> > loaded properly on a plain Python):
> > 
> > --- a/py/Makefile.am
> > +++ b/py/Makefile.am
> > @@ -7,7 +7,7 @@
> >  install-exec-local:
> >  	cd $(srcdir) && \
> >  		$(PYTHON_BIN) setup.py build --build-base $(abs_builddir) \
> > -		install --prefix $(DESTDIR)$(prefix)
> > +		install --prefix $(prefix) --root $(DESTDIR)
> >  
> >  uninstall-local:
> >  	rm -rf $(DESTDIR)$(prefix)/lib*/python*/site-packages/nftables
> 
> I proposed the following patch to remove py integration with
> autotools/automake:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230718120119.172757-2-pablo@netfilter.org/
> 
> Rationale is that this provides more flexibility to users and
> packagers to deal with nftables Python support.

More flexibility and more work. ;) Packagers still can disable python
support if they want to install it their way.

(I don't really mind either way, I'm not very happy how Python
currently likes to break stuff that worked fine for decades, really.)

-- 
Leah Neukirchen  <leah@vuxu.org>  https://leahneukirchen.org/
