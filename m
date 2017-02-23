From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnftnl] exthdr: remove unused variable uval8
Date: Thu, 23 Feb 2017 23:35:53 +0100
Message-ID: <20170223223553.GA12342@breakpoint.cc>
References: <20170223223306.24394-1-alexander@alemayhu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Alexander Alemayhu <alexander@alemayhu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45306 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751246AbdBWWhJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 17:37:09 -0500
Content-Disposition: inline
In-Reply-To: <20170223223306.24394-1-alexander@alemayhu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexander Alemayhu <alexander@alemayhu.com> wrote:
> Was added but not used in d7b451fe1a45 (src: add TCP option matching
> requirements, 2017-02-07). Fixes the following warning:
> 
> expr/exthdr.c: In function ‘nftnl_expr_exthdr_json_parse’:
> expr/exthdr.c:244:10: warning: unused variable ‘uval8’ [-Wunused-variable]
>   uint8_t uval8;
>           ^~~~~

applied, thanks.
