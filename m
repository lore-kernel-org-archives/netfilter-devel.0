From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: warnings in current tree
Date: Tue, 21 Apr 2009 12:54:06 +0200
Message-ID: <49EDA5CE.4010108@netfilter.org>
References: <20090421.014357.219275555.davem@davemloft.net> <20090421.014427.86938853.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020805000307010507060301"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20090421.014427.86938853.davem@davemloft.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020805000307010507060301
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi David!

David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 21 Apr 2009 01:43:57 -0700 (PDT)
> 
> Sorry, duh, meant netfilter-devel :-)
> 
>> Can someone fix these up?  Thanks!
>>
>> net/netfilter/nf_conntrack_netlink.c:1234: warning: 'helpname' may be used uninitialized in this function
>> net/netfilter/nf_conntrack_netlink.c:991: warning: 'helpname' may be used uninitialized in this function

Hm, weird, is this a "bogus punch"? I don't remember to have seen those
here and that code has not been modified recently.

Anyway, patch attached :).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------020805000307010507060301
Content-Type: text/x-diff;
 name="ctnl-fix-warning-gcc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctnl-fix-warning-gcc.patch"

netfilter: ctnetlink: fix gcc warning during compilation

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch fixes a (bogus?) gcc warning during compilation:

net/netfilter/nf_conntrack_netlink.c:1234: warning: 'helpname' may be used uninitialized in this function
net/netfilter/nf_conntrack_netlink.c:991: warning: 'helpname' may be used uninitialized in this function

In fact, helpname is initialized by ctnetlink_parse_help() so
I cannot see a way to use it without being initialized.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0ea36e0..fcf6e3b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -988,7 +988,7 @@ ctnetlink_change_helper(struct nf_conn *ct, struct nlattr *cda[])
 {
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_help *help = nfct_help(ct);
-	char *helpname;
+	char *helpname = NULL;
 	int err;
 
 	/* don't change helper of sibling connections */
@@ -1231,7 +1231,7 @@ ctnetlink_create_conntrack(struct nlattr *cda[],
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
- 		char *helpname;
+ 		char *helpname = NULL;
  
  		err = ctnetlink_parse_help(cda[CTA_HELP], &helpname);
  		if (err < 0)

--------------020805000307010507060301--
