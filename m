From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] ipset: fix syntax error in bash completion and hyphen
 used as minus sign in manpage
Date: Sat, 11 May 2013 09:12:32 +0700
Message-ID: <CAMQP0snoKuGx=6qO8PEZ1BQ7F6stgwC9RHrtz0RVmwGiLxWYsQ@mail.gmail.com>
References: <20130511013452.GA31273@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36242 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3EKCMc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 22:12:32 -0400
Received: by mail-pb0-f51.google.com with SMTP id wy7so3146909pbc.38
        for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2013 19:12:32 -0700 (PDT)
In-Reply-To: <20130511013452.GA31273@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I forgot one thing,

Debian lintian still warns about syntax error unless set the #!/usr/bin/env
bash

commit cf145e19be6d27cb212f95ad6f384f
d3fad7bc6b

---
 utils/ipset_bash_completion/ipset_bash_completion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/ipset_bash_completion/ipset_bash_completion
b/utils/ipset_bash_completion/ipset_bash_completion
index 69ba635..8a0b91d 100644
--- a/utils/ipset_bash_completion/ipset_bash_completion
+++ b/utils/ipset_bash_completion/ipset_bash_completion
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash

# -----------------------------------------------------------------
# Programmable completion code for ipset (netfilter.org)
--
1.7.10.4
