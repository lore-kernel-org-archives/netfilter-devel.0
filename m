From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] expr: dup: Fix json parsing
Date: Mon, 12 Oct 2015 17:55:45 +0200
Message-ID: <20151012155545.GA29494@salvia>
References: <1444338570-9254-1-git-send-email-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbbJLPsm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 11:48:42 -0400
Content-Disposition: inline
In-Reply-To: <1444338570-9254-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 08, 2015 at 05:09:30PM -0400, Aaron Conole wrote:
> fixes 760768890e60 ("src: rename existing functions...") by using the
> correct NFTNL_TYPE_U32.
> fixes 42365e5fec55 ("expr: add dup expression support...") by adding
> a declaration for the ret variable.

expr/dup.c: In function 'nftnl_expr_dup_json_parse':
expr/dup.c:120:6: warning: unused variable 'datareg_type'
[-Wunused-variable]
  int datareg_type;
      ^
expr/dup.c:118:25: warning: unused variable 'dup' [-Wunused-variable]
  struct nftnl_expr_dup *dup = nftnl_expr_data(e);
                         ^
