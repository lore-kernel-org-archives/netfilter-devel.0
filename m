Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F535EB64DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Jun 2023 15:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjFYPLc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Jun 2023 11:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjFYPLa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jun 2023 11:11:30 -0400
Received: from mail-ej1-x661.google.com (mail-ej1-x661.google.com [IPv6:2a00:1450:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8A51B7
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jun 2023 08:11:28 -0700 (PDT)
Received: by mail-ej1-x661.google.com with SMTP id a640c23a62f3a-98e1d3be004so108794266b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jun 2023 08:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ptt-ie.20221208.gappssmtp.com; s=20221208; t=1687705886; x=1690297886;
        h=mime-version:message-id:date:reply-to:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wqq4uIFbPmIYmGnD4oi4N5iew1ED+VVJ9JrQXNznywg=;
        b=4C5DTzsqJD8AJnfW8BdSTlUmulumo/X5OLpyftlg4d2vdgsXcgwgJ2oafg9RzeQo6l
         uU8CiZbfw17VBmcuuErqN61qVG4FPUUN4zbe0CASr/uXBGA2Foixts4x3i0II+yIhFxb
         lTvjlm2BIa/qp97dQ0+ymOXDMseic+h9oPJXb6FrAi7R+APO6kxZQiDxBs24LJSwkcps
         Zuc4kyvZeHM7CAxK8zPFAOR4GHc2gwGs81MNuLcHzYV+2j9eCblllHD1FOqZths1mn4q
         mwGYbx0kv7AMlqyf3pmf1RyvPZ+XIoH+1p2zlxaanRG4OX32krdY9VtkDNzazseACt5Q
         JgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687705886; x=1690297886;
        h=mime-version:message-id:date:reply-to:references:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wqq4uIFbPmIYmGnD4oi4N5iew1ED+VVJ9JrQXNznywg=;
        b=UEO79upfNULoolF1Yt8QwQ2pXf50/vCp5cK2ELkP50yqx3fzn8Zl4rtVFtqSIaLHhn
         pxIrtctDZ/PUnJfCZKWAEJr8nWKTAOniJKy1uk6pasuCp1n3S76wFj6SvtBRqfWeGung
         9A9P/JvNoOaGdbTG1cD9ESMf9Uk+1D9p4sESa35pczjcFtju+CTyDZtOkXsLugYirW4k
         b00Wd4PzSz2JatDi08FIw6Wkuf3T3U+3bky5nRrFAtKnhSAh1LTfmFNl4XmwlH0Y5gxn
         poVtjD4qRVUaT0DKLLnBLHsVacY3UMCFsTowYPQC/I4sC4FpUAuvRgR1t0rQao1cyX4B
         FE+Q==
X-Gm-Message-State: AC+VfDw46yPOY4mLztePG8mLfy1KCe1VuUEqjIJ9gni/Bnids7Ad4AnH
        y0V4pkmcccaXLO16DJeEzL7+1k+05101MPd6nCTOFUzsrhws8A==
X-Google-Smtp-Source: ACHHUZ4mIBdoa244ym+CJ7TAVtudzrUBAi/hD3gh2p2Xo0qJRS3rYG4A2Hp+PaE/ImaZA4vBE/NXLOtNisvM
X-Received: by 2002:a17:906:8a74:b0:98d:dd76:7201 with SMTP id hy20-20020a1709068a7400b0098ddd767201mr3065010ejc.16.1687705886417;
        Sun, 25 Jun 2023 08:11:26 -0700 (PDT)
Received: from jvdspc.jvds.net ([212.129.74.237])
        by smtp-relay.gmail.com with ESMTPS id e2-20020a170906080200b009821818dc1esm290661ejd.204.2023.06.25.08.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 08:11:26 -0700 (PDT)
X-Relaying-Domain: ptt.ie
Received: from jvdspc.jvds.net (localhost.localdomain [127.0.0.1])
        by jvdspc.jvds.net (8.17.1/8.17.1) with ESMTPS id 35PFBOtB150421
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 25 Jun 2023 16:11:24 +0100
Received: (from jvd@localhost)
        by jvdspc.jvds.net (8.17.1/8.17.1/Submit) id 35PFBIni150394;
        Sun, 25 Jun 2023 16:11:18 +0100
From:   "Jason Vas Dias" <jason.vas.dias@ptt.ie>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        jason.vas.dias@gmail.com
Subject: RE: Linux netfilter / iptables : How to enable iptables TRACE chain
 handling with nf_log_syslog on RHEL8+? 
In-Reply-To:    <20230625134039.GB3207@breakpoint.cc>
References:     <hhttuv65e9.fsf@jvdspc.jvds.net>
Reply-To: "Jason Vas Dias" <jason.vas.dias@ptt.ie>,
          "Jason Vas Dias" <jason.vas.dias@gmail.com>
Date:   Sun, 25 Jun 2023 16:11:18 +0100
Message-ID: <hhr0pz60h5.fsf@jvdspc.jvds.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Good day Florian -

  RE: you wrote:
  > Run "xtables-monitor --trace".

  Thanks for the info about xtables-monitor - yes, that does give alot
  of extra information about rule chain processing.

  But I'd just like to understand :
    Why does this work under kernel v6.2.16 and not under v4.18.0-477 ?
    :
    # iptables -t raw -A PREROUTING -p icmp -j TRACE
    # iptables -t raw -A OUTPUT -p icmp -j TRACE
    # modprobe nf_log_ipv4
    # echo nf_log_ipv4 > /proc/sys/net/netfilter/nf_log/2

  How can I enable the 'nf_log_syslog' module, so that it does
  in fact emit TRACE kernel messages to syslog, as it purports
  to be able to do, under v4.18.0-477 ?

  xtables-monitor is great, it provides ALOT of information, but
  really I'd like to just trace packet ingress / egress to from
  interfaces, with messages written to syslog .  Has this functionality
  been disabled somehow from the 'nf_log_syslog' module in v4.18.0-477 ?
  If so, how can I enable it ?

  There is very little documentation about nf_log_syslog, besides that
  it is meant to take over everything done by ipt_LOG .

  ipt_LOG WAS meant to log packets that meet the rules on the TRACE
  chain to syslog, no ? So how can I enable that functionality only
  with nf_log_syslog under v4.18.0-477 ?

  I am reading its source code, it SEEMS like it should be getting
  triggered when 'sysctl netfilter.nf_log.2' is not NONE, no ?
  But the v4.18.0-477 version of it it is not doing so.  Why ?

Best Regards,
Jason

 
 
