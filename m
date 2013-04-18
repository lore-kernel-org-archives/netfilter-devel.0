From: Dash Four <mr.dash.four@googlemail.com>
Subject: xtables-addons compile error (DNETMAP)
Date: Thu, 18 Apr 2013 23:36:38 +0100
Message-ID: <51707576.5010505@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64607 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3DRWgv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:36:51 -0400
Received: by mail-wi0-f169.google.com with SMTP id h11so76263wiv.0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2013 15:36:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

During build I get the following error:

xt_DNETMAP.c: In function 'dnetmap_tg_check':
xt_DNETMAP.c:331: error: incompatible types when assigning to type 
'kuid_t' from type 'unsigned int'
xt_DNETMAP.c:332: error: incompatible types when assigning to type 
'kgid_t' from type 'unsigned int'
xt_DNETMAP.c:344: error: incompatible types when assigning to type 
'kuid_t' from type 'unsigned int'
xt_DNETMAP.c:345: error: incompatible types when assigning to type 
'kgid_t' from type 'unsigned int'

The target kernel is 3.8.7. Any idea what could cause this?
