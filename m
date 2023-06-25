Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9D0EB64DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Jun 2023 13:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjFYNZI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Jun 2023 09:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjFYNZH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jun 2023 09:25:07 -0400
Received: from mail-wm1-x365.google.com (mail-wm1-x365.google.com [IPv6:2a00:1450:4864:20::365])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7411AD
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jun 2023 06:25:06 -0700 (PDT)
Received: by mail-wm1-x365.google.com with SMTP id 5b1f17b1804b1-3f900cd3f96so30748745e9.2
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jun 2023 06:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ptt-ie.20221208.gappssmtp.com; s=20221208; t=1687699504; x=1690291504;
        h=mime-version:message-id:date:reply-to:cc:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rdx+jmpZvU2v1S6IQOE0hbmqHzeCs2MU52rIPQmTrDI=;
        b=GKXN7WTTkBZsPTq5uXszzK7LhaJmNvfszWgpK4YmwlLFc54cgYsH7QN5OoAzaY82n5
         wTyke1eUmYzAmDj5kgvVFt0LKJG4qwFjF82VT6ZKawtI6dZs3RX4st0ig4L6IwLAnAMH
         PB0w0TxomQ2jtFh302AoZTjwnDAcbqS/ymTafravne1Hx5GnHVr/vvnyuv0sRQLapjHX
         8RRTnWj4MV6WlfLn1Si85IKun3sGg5Es3BgkRgw1ExsZO0FRHSlJMHL0KCsuT/jYXiTs
         RchtO7MLa4/z+CJkkwl/xWRg0EvfThy2Tog69IRCrRcPOXiIDeWMFKM2WlsW/V9LRcIU
         NsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687699504; x=1690291504;
        h=mime-version:message-id:date:reply-to:cc:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rdx+jmpZvU2v1S6IQOE0hbmqHzeCs2MU52rIPQmTrDI=;
        b=R7UOyyjDNdGZHF1fin7NnSz7+fc+mU2jigV2TwVMEMOM6ARcXcFK4Rh0NDBp7146rH
         c7k/+wptmBiUQi3uxdLiBqfizhCPICrrAelHh6eC87SuruUbVFel1QGDukZaS4NmM77G
         QdJB1w7rdqD386y3O7C4rN9DE7Sgn5bVW0husUxhR0e+O+3sKesfonP1urfVptnvSsIW
         GcnBfg2vDDXIk319qq8Oj/e3vrTs1rvc/LDwe59BpUQQh0W3BbsRwrgIlTS2r2PlWvQ9
         SmYV15x0VZd5na7JNXn/bzdAUlpf/4zYWh2qx/KiAYyth6fuzV2yt0KKnRHCYjnDuEoG
         NZvw==
X-Gm-Message-State: AC+VfDweeCNsupWwhQGO6DO/PUrMF70iNTNlftVCtBkS2mEyQ4eAtCFs
        8B83F1KFlYqnabCGM92akG6zpJeWgJIQne91AqYJ0Iy8zD264Q==
X-Google-Smtp-Source: ACHHUZ6fesUR6WWMzW4nxW93WJLExgmlXvDxHpXAyZxF5qbVHbYSqE/8qFyCba1oOeaj0ASwfH9OpfcFmuJc
X-Received: by 2002:a7b:cd16:0:b0:3f9:b12b:54e5 with SMTP id f22-20020a7bcd16000000b003f9b12b54e5mr15392836wmj.21.1687699504029;
        Sun, 25 Jun 2023 06:25:04 -0700 (PDT)
Received: from jvdspc.jvds.net ([212.129.83.207])
        by smtp-relay.gmail.com with ESMTPS id h7-20020a1ccc07000000b003fa5fd8e886sm271511wmb.44.2023.06.25.06.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 06:25:04 -0700 (PDT)
X-Relaying-Domain: ptt.ie
Received: from jvdspc.jvds.net (localhost.localdomain [127.0.0.1])
        by jvdspc.jvds.net (8.17.1/8.17.1) with ESMTPS id 35PDP2bj141400
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 25 Jun 2023 14:25:02 +0100
Received: (from jvd@localhost)
        by jvdspc.jvds.net (8.17.1/8.17.1/Submit) id 35PDP2Pm141399;
        Sun, 25 Jun 2023 14:25:02 +0100
From:   "Jason Vas Dias" <jason.vas.dias@ptt.ie>
To:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Linux netfilter / iptables : How to enable iptables TRACE chain
 handling with nf_log_syslog on RHEL8+?
cc:     "Jason Vas Dias" <jason.vas.dias@gmail.com>,
        "Jason Vas Dias" <jason.vas.dias@ptt.ie>
Reply-To: "Jason Vas Dias" <jason.vas.dias@ptt.ie>,
          "Jason Vas Dias" <jason.vas.dias@gmail.com>
Date:   Sun, 25 Jun 2023 14:25:02 +0100
Message-ID: <hhttuv65e9.fsf@jvdspc.jvds.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Good day -

  On a Linux RHEL8 system, I have enabled these iptables rules,
  which I am led to believe should enable ICMP packet syslog
  logging on interface ingress & egress :

    # iptables -L -t raw
    Chain PREROUTING (policy ACCEPT)
    target     prot opt source               destination         
    TRACE      icmp --  anywhere             anywhere            

    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
    TRACE      icmp --  anywhere             anywhere            

  As described at : https://access.redhat.com/solutions/2313671 I have done :

    # modprobe  nf_log_ipv4
    # sysctl -w net.netfilter.nf_log.2=nf_log_ipv4

  I also did:

    # modprobe nf_log_syslog

  which I am led to believe replaces all previous nf_log* or ipt_LOG
  modules in modern (RHEL8 4.18.x+) kernels.

  But, when I 'ping' a NAT'd (with iptables) IP address,
  no TRACE log messages appear in 'dmesg -c' output or in
  syslog (systemd.journald in use).

  What am I missing ?

  The most comprehensive discussion I have found on this issue so far on the web is at :

  https://backreference.org/2010/06/11/iptables-debugging/ (thanks waldner!)

  But this is getting rather old (2010-06-11) , and evidently does not
  apply to kernel 4.18+(RHEL) .

  I have duplicated precisely the steps above on Fedora-36
  (kernel v6.2.16) system , and it DOES work, TRACE log messages ARE generated :

  # iptables -t raw -A PREROUTING -p icmp -j TRACE
  # iptables -t raw -A OUTPUT -p icmp -j TRACE
  # modprobe nf_log_ipv4
  # echo nf_log_ipv4 > /proc/sys/net/netfilter/nf_log/2

  But, these steps, when repeated on a RHEL8 kernel 4.18.0-477.13.1
  host, do not work or produce any packet TRACE output in logs -
  this is what I am tearing what remains of my hair out trying to resolve.

  Thanks in advance for any informative replies .

Best Regards,
Jason Vas Dias (SW+SYS+NET)-Engineer, West Cork, Eire.
