Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642E6C25B0E
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Aug 2022 16:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbiHPQXH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Aug 2022 12:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiHPQXC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Aug 2022 12:23:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90C379A49;
        Tue, 16 Aug 2022 09:22:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7036137645;
        Tue, 16 Aug 2022 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660666978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJeBNMRfo88AxUhhWQ0t4TxTFqdEjT8eIfnKmX+Lkrg=;
        b=WW4MUIcKFTW5QnJMfkOhGqQ9Ap07SJnZhbgBx/dohfT7e2Z1OL7W8xqmuLKft9LMUWxfcI
        y/KwYl268nHGVBftHhct+wj3WtE7/dJ9E4RiCM+wxiz9/DT/SZWatp2z01dvM2QyPYTA6R
        p10LH3P4I/yk2uq+gnSuRCG0aK36r7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660666978;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oJeBNMRfo88AxUhhWQ0t4TxTFqdEjT8eIfnKmX+Lkrg=;
        b=rGUG0IM+6XGR+A0FCPwffxIyze32E0j/WMhhR1nD30ck//eiHvp0le+J6VxRS85PTXk0cI
        va8HOkEWAOes9HAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 53C63139B7;
        Tue, 16 Aug 2022 16:22:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zxpoFGLE+2LQNwAAMHmgww
        (envelope-from <jwiesner@suse.de>); Tue, 16 Aug 2022 16:22:58 +0000
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 53E0DDB70; Tue, 16 Aug 2022 18:22:57 +0200 (CEST)
Date:   Tue, 16 Aug 2022 18:22:57 +0200
From:   Jiri Wiesner <jwiesner@suse.de>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     netfilter-devel@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org
Subject: Re: [RFC PATCH nf-next] netfilter: ipvs: Divide estimators into
 groups
Message-ID: <20220816162257.GA18621@incl>
References: <20220812103459.GA7521@incl>
 <f1657ace-59fb-7265-faf8-8a1a26aaf560@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1657ace-59fb-7265-faf8-8a1a26aaf560@ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 13, 2022 at 03:11:48PM +0300, Julian Anastasov wrote:
> > The intention is to develop this RFC patch into a short series addressing
> > the design changes proposed in [1]. Also, after moving the rate estimation
> > out of softirq context, the whole estimator list could be processed
> > concurrently - more than one work item would be used.
> 
> 	Other developers tried solutions with workqueues
> but so far we don't see any results. Give me some days, may be
> I can come up with solution that uses kthread(s) to allow later
> nice/cpumask cfg tuning and to avoid overload of the system
> workqueues.

The RFC patch already resolves the issue despite having the code still run in softirq context. Even if estimators were processed in groups, moving the rate estimation out of softirq context is a good idea. I am interested in implementing this. An alternative approach would be moving the rate estimation out of softirq context and reworking locking so that cond_resched() could be used to let other processes run as the scheduler sees fit. I would be willing to try to implement this alternative approach as well.
Jiri Wiesner
SUSE Labs
