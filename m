Return-Path: <SRS0=ECng=UI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFBDC28EBD
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jun 2019 16:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD25820657
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jun 2019 16:23:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=brauner.io header.i=@brauner.io header.b="RGk2eK93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfFIQXV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jun 2019 12:23:21 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33706 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728703AbfFIQXV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jun 2019 12:23:21 -0400
Received: by mail-ed1-f68.google.com with SMTP id h9so10534871edr.0
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Jun 2019 09:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7DVC0/uiSTBqozKjpL2lztjn7upfih/z+bOVWSHs3GU=;
        b=RGk2eK93ZiEJPgkhLoILYOX9fmoTjER9GIhmCHW2weCRphBKUIBtT+4Jvn17m5oXDF
         LA1FShm3G1OTeFXqxHGc+IJNVM7NudBE8QQIxssr6zbO2CebqCOIk/v0Ez/Fw4f1JuxD
         LMVrWRIZlX2R7mz4sNARcGYJDgOQf3Js7JzbOdpQg8c/WFHqQdu3Vq9Psc2vcwrQKnGj
         J420O0BBi5s0CjY+TbillB/YtpkxdR3Uefv09DOg9Sf1H93wAlh7qmswtLK/9YF1OldY
         R1eViaCVuUNpviZ5g/I0Kh/Kln1Vux5VCy4HPTd4xa65nxsYIP2kddV422zrU4zO/Blf
         UN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7DVC0/uiSTBqozKjpL2lztjn7upfih/z+bOVWSHs3GU=;
        b=RWSV8vQeBHULKO6E4NXBxwkan0bqfTYVqLBYp8C0wbYg8YgtwMV9O5EMyD3LlAaDT/
         kgprRn4jnj3jXnOj6mZ/OCyMmCSTHFTnzAE2jU7trTtUWIMKWq89DUAjBS+riAfBFHCR
         EiFJiA9kknWa64WSzI75139MjTs2V1DOMvfBdG+egdOWoB09OVFc5WQmikwpRopGM6al
         cijCc7QFHX/gkgGFOdHdgCIwRDzjaDspFpjXuoQ83tfYxW6xWUIyk16kNZbakL2VauNA
         z7UmM1Mp5yASwZM9H8z9MTJXOVTu1kI751ysMdjbYL3T/H8wXwMX8d+PWHR/2/syUnxq
         9uSg==
X-Gm-Message-State: APjAAAV9CisgwKUruzJjMdjJvFn4L5EvXYdfhlCDz6sT3iwFYolyMuhr
        sZZ71swMviIOB195/r5dobulXQ==
X-Google-Smtp-Source: APXvYqxlMVg9vnSVRsQHUpfB2JSCZ9E7+bhFFVyhiBzP3+OhLOXa/0ZBe7AKt+td6mO2I+loLlf9zw==
X-Received: by 2002:a17:906:308a:: with SMTP id 10mr16029454ejv.124.1560097399433;
        Sun, 09 Jun 2019 09:23:19 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bd67a.dynamic.kabel-deutschland.de. [95.91.214.122])
        by smtp.gmail.com with ESMTPSA id r12sm1069489eda.39.2019.06.09.09.23.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 09 Jun 2019 09:23:18 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Cc:     tyhicks@canonical.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH net-next v1 0/1] br_netfilter: enable in non-initial netns
Date:   Sun,  9 Jun 2019 18:23:03 +0200
Message-Id: <20190609162304.3388-1-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey everyone,

/* v1 */
This is a rework of the patch to not touch struct net at all and instead
rely on the pernet infrastructure directly to namespace the sysctls.

/* v0 */
This is another resend of the same patch series. I have received so many
requests, pings, and questions that I would really like to push for this
again.

Over time I have seen multiple reports by users who want to run applications
(Kubernetes e.g. via [1]) that require the br_netfilter module in
non-initial network namespaces. There are *a lot* of issues for this. A
shortlist including ChromeOS and other big users is found below under
[2]! Even non-devs already tried to get more traction on this by
commenting on the patchset (cf. [3]).

Currently, the /proc/sys/net/bridge folder is only created in the
initial network namespace. This patch series ensures that the
/proc/sys/net/bridge folder is available in each network namespace if
the module is loaded and disappears from all network namespaces when the
module is unloaded.
The patch series also makes the sysctls:

bridge-nf-call-arptables
bridge-nf-call-ip6tables
bridge-nf-call-iptables
bridge-nf-filter-pppoe-tagged
bridge-nf-filter-vlan-tagged
bridge-nf-pass-vlan-input-dev

apply per network namespace. This unblocks some use-cases where users
would like to e.g. not do bridge filtering for bridges in a specific
network namespace while doing so for bridges located in another network
namespace.
The netfilter rules are afaict already per network namespace so it
should be safe for users to specify whether a bridge device inside their
network namespace is supposed to go through iptables et al. or not.
Also, this can already be done by setting an option for each individual
bridge via Netlink. It should also be possible to do this for all
bridges in a network namespace via sysctls.

Thanks!
Christian

[1]: https://github.com/zimmertr/Bootstrap-Kubernetes-with-Ansible
[2]: https://bugs.chromium.org/p/chromium/issues/detail?id=878034 
     https://github.com/lxc/lxd/issues/5193
     https://discuss.linuxcontainers.org/t/bridge-nf-call-iptables-and-swap-error-on-lxd-with-kubeadm/2204
     https://github.com/lxc/lxd/issues/3306
     https://gitlab.com/gitlab-org/gitlab-runner/issues/3705
     https://ubuntuforums.org/showthread.php?t=2415032
     https://medium.com/@thomaszimmerman93/hi-im-unable-to-get-kubeadm-init-to-run-due-to-br-netfilter-not-being-loaded-within-the-5642a4ccfece
[3]: https://lkml.org/lkml/2019/3/7/365

*** BLURB HERE ***

Christian Brauner (1):
  br_netfilter: namespace bridge netfilter sysctls

 include/net/netfilter/br_netfilter.h |   3 +-
 net/bridge/br_netfilter_hooks.c      | 291 ++++++++++++++++++---------
 net/bridge/br_netfilter_ipv6.c       |   2 +-
 3 files changed, 204 insertions(+), 92 deletions(-)

-- 
2.21.0

