Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20912C636CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Feb 2023 11:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjBGLuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 06:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjBGLuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 06:50:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815552128D
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2023 03:50:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CA243336C4;
        Tue,  7 Feb 2023 11:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1675770620;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T77Qetwup3EsOnLLSa2giebdMOevf8gtwN5HAxvyseA=;
        b=alC9PkLuUyyrnr3DAhP85EnqkJzdREDxAppbkAyQkd9WYnvZYDfd2Q2WPBbdRi9zDuAJAw
        879ec+HZC+ab+t+SLpTjoVQ7FqOmHDw5EV1nPqWAOCrzu9SIxXOLCtl13CdTZYAWbISSqG
        AlGjotSH1DlM3ZXNAvQAhT3Y8jQ/4U4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1675770620;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T77Qetwup3EsOnLLSa2giebdMOevf8gtwN5HAxvyseA=;
        b=ug0s3iQL3DvaEiTq3HzvHdBG8hv76B0M1B4VU6yHimVUAmAG5eEz2M4+04WcQphJlFUkqV
        C8bOdK6Y731XAXBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86916139ED;
        Tue,  7 Feb 2023 11:50:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Fr+hHvw64mMORwAAMHmgww
        (envelope-from <pvorel@suse.cz>); Tue, 07 Feb 2023 11:50:20 +0000
Date:   Tue, 7 Feb 2023 12:50:18 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     ltp@lists.linux.it
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] iptables_lib.sh: Fix for iptables-translate >= v1.8.9
Message-ID: <Y+I6+vfJChwbC114@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20230206170325.19813-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206170325.19813-1-pvorel@suse.cz>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

FYI merged.

Kind regards,
Petr
