Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D117C25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 15:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjJZPKN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 11:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjJZPKN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 11:10:13 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FBA1B6
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 08:10:09 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id A45F2589164F4; Thu, 26 Oct 2023 17:10:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id A199060EB154C;
        Thu, 26 Oct 2023 17:10:07 +0200 (CEST)
Date:   Thu, 26 Oct 2023 17:10:07 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 07/10] man: grammar fixes to some manpages
In-Reply-To: <ZTphOV/bYuotL2l0@orbyte.nwl.cc>
Message-ID: <nn5s78o8-170p-rn49-97np-4082so7q1s20@vanv.qr>
References: <20231026085506.94343-1-jengelh@inai.de> <20231026085506.94343-7-jengelh@inai.de> <ZTphOV/bYuotL2l0@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2023-10-26 14:53, Phil Sutter wrote:
>> diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
>> index e2009086..7cc2bb7a 100644
>> --- a/extensions/libxt_MASQUERADE.man
>> +++ b/extensions/libxt_MASQUERADE.man
>> @@ -15,7 +15,7 @@ any established connections are lost anyway).
>>  \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
>>  This specifies a range of source ports to use, overriding the default
>>  .B SNAT
>> -source port-selection heuristics (see above).  This is only valid
>> +source port-selection heuristics (see above). This is only valid
>
>Do you miss a dash in:
>
>"default SNAT source port selection heuristics"? I lean towards putting
>dashes everywhere, but my language spoils me. ;)

Third time's the charm, hopefully?




The following changes since commit ccecb1b90ae2af6e963d27ada8d5fd69d40231c4:

  extensions: string: Adjust description of --to to recent kernel changes (2023-10-25 17:23:57 +0200)

are available in the Git repository at:

  https://github.com/jengelh/iptables 

for you to fetch changes up to 0342b75582b98a175ee804fa636161e91be1d696:

  man: reveal rateest's combination categories (2023-10-26 15:56:24 +0200)

----------------------------------------------------------------
Jan Engelhardt (7):
      man: display number ranges with an en dash
      man: encode minushyphen the way groff/man requires it
      man: encode emdash the way groff/man requires it
      man: encode hyphens the way groff/man requires it
      man: consistent casing of "IPv[46]"
      man: grammar fixes to some manpages
      man: use native bullet point markup

Phil Sutter (2):
      man: use .TP for lists in xt_osf man page
      man: reveal rateest's combination categories

 extensions/libip6t_DNPT.man     |  2 +-
 extensions/libip6t_REJECT.man   |  7 ++++---
 extensions/libip6t_SNPT.man     |  2 +-
 extensions/libipt_REJECT.man    |  7 ++++---
 extensions/libipt_ULOG.man      |  4 ++--
 extensions/libxt_CT.man         |  4 ++--
 extensions/libxt_HMARK.man      |  2 +-
 extensions/libxt_LED.man        |  4 ++--
 extensions/libxt_MASQUERADE.man |  6 +++---
 extensions/libxt_NFLOG.man      |  4 ++--
 extensions/libxt_NFQUEUE.man    | 11 ++++++-----
 extensions/libxt_SET.man        |  4 ++--
 extensions/libxt_SNAT.man       |  2 +-
 extensions/libxt_SYNPROXY.man   |  4 ++--
 extensions/libxt_TRACE.man      |  4 ++--
 extensions/libxt_bpf.man        |  8 ++++----
 extensions/libxt_cgroup.man     |  2 +-
 extensions/libxt_cluster.man    |  8 ++++----
 extensions/libxt_connlabel.man  | 10 +++++-----
 extensions/libxt_connlimit.man  | 31 ++++++++++++++++++-------------
 extensions/libxt_cpu.man        |  2 +-
 extensions/libxt_dscp.man       |  2 +-
 extensions/libxt_hashlimit.man  |  6 +++---
 extensions/libxt_helper.man     | 10 +++++-----
 extensions/libxt_limit.man      |  2 +-
 extensions/libxt_nfacct.man     |  2 +-
 extensions/libxt_osf.man        | 40 +++++++++++++++++++++++++---------------
 extensions/libxt_owner.man      |  2 +-
 extensions/libxt_rateest.man    | 16 ++++++++++------
 extensions/libxt_socket.man     |  2 +-
 extensions/libxt_time.man       |  2 +-
 extensions/libxt_u32.man        | 16 ++++++++--------
 iptables/ebtables-nft.8         | 22 +++++++++++-----------
 33 files changed, 136 insertions(+), 114 deletions(-)
