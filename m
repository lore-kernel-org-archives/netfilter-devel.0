From: Arif Hossain <etothepowerpi@gmail.com>
Subject: skb_* function to get pointer to udp payload
Date: Tue, 07 Aug 2012 19:42:41 +0600
Message-ID: <1344346961.4763.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34072 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGNxb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:53:31 -0400
Received: by yhmm54 with SMTP id m54so3666394yhm.19
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Aug 2012 06:53:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I need to get a pointer to udp payload in my xtables module in following
scenario:

1. From NF_INET_LOCAL_PREROUTING hook. As Transport headers are not yet
initialized, may be i need to play with offsets like
skb_header_pointer(skb, par->thoff,....). Not sure if its correct to use
skb_header_pointer this way though.

2. From NF_INET_LOCAL_OUT. This time as transport fields are already
initialized, i guess there is a direct function to get pointer to udp
payload.

Thanks in advance. 
-- 
Cheers

aft
aftnix@gmail.com

