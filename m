From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 libnftnl] Check all strdup
Date: Wed, 8 Jun 2016 13:07:01 +0200
Message-ID: <20160608110701.GA919@salvia>
References: <1464689312-8136-1-git-send-email-carlosfg@riseup.net>
 <20160607150810.GA17951@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbcFHLHK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 07:07:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 09B564506E8
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 13:07:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ECCB3158F13
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 13:07:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 428BB158F15
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 13:07:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160607150810.GA17951@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jun 07, 2016 at 05:08:10PM +0200, Pablo Neira Ayuso wrote:
> Carlos,
> 
> On Tue, May 31, 2016 at 12:08:32PM +0200, Carlos Falgueras García wrote:
> > Check all strdup possible error and treat it consequently.
> 
> Please, manually apply these two patches in your local working copy:
> 
> http://patchwork.ozlabs.org/patch/631659/
> http://patchwork.ozlabs.org/patch/631660/
> 
> Then, continue with the patch that I'm attaching.
> 
> As you can see, the idea is to return an integer for _set_data() and
> _set_str(), so the caller can check if the internal string allocation
> that the library performs has failed.

Forgot attachment, this is what I'm requesting you to continue.

--YZ5djTAD1cGYuMQK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index 954b39f..ed21e48 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -37,13 +37,13 @@ enum nftnl_chain_attr {
 bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr);
 void nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void *data);
-void nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
+int nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
 			     const void *data, uint32_t data_len);
 void nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_t data);
 void nftnl_chain_set_u32(struct nftnl_chain *t, uint16_t attr, uint32_t data);
 void nftnl_chain_set_s32(struct nftnl_chain *t, uint16_t attr, int32_t data);
 void nftnl_chain_set_u64(struct nftnl_chain *t, uint16_t attr, uint64_t data);
-void nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const char *str);
+int nftnl_chain_set_str(struct nftnl_chain *t, uint16_t attr, const char *str);
 
 const void *nftnl_chain_get(const struct nftnl_chain *c, uint16_t attr);
 const void *nftnl_chain_get_data(const struct nftnl_chain *c, uint16_t attr,
diff --git a/src/chain.c b/src/chain.c
index 70daaf3..75ab840 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -165,11 +165,13 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MAX + 1] = {
 	[NFTNL_CHAIN_FAMILY]		= sizeof(uint32_t),
 };
 
-void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
-			     const void *data, uint32_t data_len)
+int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
+			 const void *data, uint32_t data_len)
 {
-	if (attr > NFTNL_CHAIN_MAX)
-		return;
+	if (attr > NFTNL_CHAIN_MAX) {
+		errno = -EOPNOTSUPP;
+		return -1;
+	}
 
 	nftnl_assert_validate(data, nftnl_chain_validate, attr, data_len);
 
@@ -182,6 +184,8 @@ void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			xfree(c->table);
 
 		c->table = strdup(data);
+		if (!c->table)
+			return -1;
 		break;
 	case NFTNL_CHAIN_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
@@ -212,15 +216,20 @@ void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			xfree(c->type);
 
 		c->type = strdup(data);
+		if (!c->type)
+			return -1;
 		break;
 	case NFTNL_CHAIN_DEV:
 		if (c->dev)
 			xfree(c->dev);
 
 		c->dev = strdup(data);
+		if (!c->type)
+			return -1;
 		break;
 	}
 	c->flags |= (1 << attr);
+	return 0;
 }
 EXPORT_SYMBOL(nftnl_chain_set_data);
 
@@ -254,9 +263,9 @@ void nftnl_chain_set_u8(struct nftnl_chain *c, uint16_t attr, uint8_t data)
 }
 EXPORT_SYMBOL(nftnl_chain_set_u8);
 
-void nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
+int nftnl_chain_set_str(struct nftnl_chain *c, uint16_t attr, const char *str)
 {
-	nftnl_chain_set_data(c, attr, str, strlen(str));
+	return nftnl_chain_set_data(c, attr, str, strlen(str));
 }
 EXPORT_SYMBOL(nftnl_chain_set_str);
 

--YZ5djTAD1cGYuMQK--
