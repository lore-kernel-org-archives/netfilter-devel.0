From: Alexander Alemayhu <alexander@alemayhu.com>
Subject: Re: [PATCH iptables] iptables-translate: print nft iff there are
 more expanded rules to print
Date: Thu, 9 Mar 2017 12:27:50 +0100
Message-ID: <20170309112750.GC29821@gmail.com>
References: <1489057244-3611-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:35426 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbdCIL2a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 06:28:30 -0500
Received: by mail-wr0-f182.google.com with SMTP id g10so42895287wrg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Mar 2017 03:27:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1489057244-3611-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 09, 2017 at 12:00:44PM +0100, Pablo Neira Ayuso wrote:
> $ iptables-translate -I INPUT -s yahoo.com
> nft insert rule ip filter INPUT ip saddr 98.139.183.24 counter
> nft insert rule ip filter INPUT ip saddr 206.190.36.45 counter
> nft insert rule ip filter INPUT ip saddr 98.138.253.109 counter
> nft
> 
> This extra 'nft' print is incorrect, just print it if there are more
> rules to be printed.
> 
> Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Alexander Alemayhu <alexander@alemayhu.com>

-- 
Mit freundlichen Grüßen

Alexander Alemayhu
