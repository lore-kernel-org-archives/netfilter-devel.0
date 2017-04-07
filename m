From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] iptables: iptables: Constify option struct
Date: Fri, 7 Apr 2017 20:33:32 +0200
Message-ID: <20170407183332.GA18551@salvia>
References: <20170402070508.20770-1-arushisinghal19971997@gmail.com>
 <20170402070508.20770-2-arushisinghal19971997@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Arushi Singhal <arushisinghal19971997@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755774AbdDGSdq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 14:33:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 591901395C8
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 20:33:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B5DFDA862
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 20:33:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2051BDA848
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 20:33:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170402070508.20770-2-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 02, 2017 at 12:35:08PM +0530, Arushi Singhal wrote:
> The structs of the type option are not modified anywhere.

xtables-eb.c: In function ‘ebt_load_match_extensions’:
xtables-eb.c:653:7: warning: assignment discards ‘const’ qualifier
from pointer target type
  opts = ebt_original_options;


You don't compile test your patches :(
