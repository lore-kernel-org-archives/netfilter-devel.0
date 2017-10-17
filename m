From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 13:31:50 +0200
Message-ID: <20171017113150.GA8818@salvia>
References: <20171017110507.GA16060@salvia>
 <20171017112218.14539-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+HP7ph2BbKc20aGI"
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37616 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932880AbdJQLbz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:31:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A7BA112063
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:31:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96C74DA873
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 13:31:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171017112218.14539-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 17, 2017 at 01:22:18PM +0200, Phil Sutter wrote:
> Implement expression printing into a FILE pointer analogous to
> nftnl_rule_fprintf().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Update src/libnftnl.map

Thanks Phil.

I think we need to collapse this change to your patch.

--+HP7ph2BbKc20aGI
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/libnftnl.map b/src/libnftnl.map
index a01a6599a975..74f33c438a16 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -103,7 +103,6 @@ global:
   nftnl_expr_get_u64;
   nftnl_expr_get_str;
   nftnl_expr_snprintf;
-  nftnl_expr_fprintf;
   nftnl_expr_free;
 
   nftnl_rule_list_alloc;
@@ -308,3 +307,7 @@ global:
 
 local: *;
 };
+
+LIBNFTNL_6 {
+  nftnl_expr_fprintf;
+} LIBMNL_5;

--+HP7ph2BbKc20aGI--
