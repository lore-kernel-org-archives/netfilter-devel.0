From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 2/4 v6] libnftnl: rule: Change the "userdata" attribute to
 use new TLV buffer
Date: Thu, 14 Apr 2016 19:55:42 +0200
Message-ID: <570FD99E.7040708@riseup.net>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
 <1458675987-32398-2-git-send-email-carlosfg@riseup.net>
 <20160413235918.GA12737@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50754 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbcDNRzt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 13:55:49 -0400
In-Reply-To: <20160413235918.GA12737@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14/04/16 01:59, Pablo Neira Ayuso wrote:
> On Tue, Mar 22, 2016 at 08:46:25PM +0100, Carlos Falgueras Garc=EDa w=
rote:
>> diff --git a/src/rule.c b/src/rule.c
>> index 3a32bf6..db96e5b 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -28,6 +28,7 @@
>>   #include <libnftnl/rule.h>
>>   #include <libnftnl/set.h>
>>   #include <libnftnl/expr.h>
>> +#include <libnftnl/udata.h>
>>
>>   struct nftnl_rule {
>>   	struct list_head head;
>> @@ -38,10 +39,7 @@ struct nftnl_rule {
>>   	const char	*chain;
>>   	uint64_t	handle;
>>   	uint64_t	position;
>> -	struct {
>> -			void		*data;
>> -			uint32_t	len;
>> -	} user;
>> +	struct nftnl_udata_buf	*userdata;
>
> This change, we don't need it, see below.
>
>> @@ -162,8 +171,14 @@ void nftnl_rule_set_data(struct nftnl_rule *r, =
uint16_t attr,
>>   		r->position =3D *((uint64_t *)data);
>>   		break;
>>   	case NFTNL_RULE_USERDATA:
>> -		r->user.data =3D (void *)data;
>> -		r->user.len =3D data_len;
>> +		if (r->flags & (1 << NFTNL_RULE_USERDATA))
>> +			nftnl_udata_buf_free(r->userdata);
>> +		r->userdata =3D nftnl_udata_buf_alloc(data_len);
>> +		if (!r->userdata) {
>> +			perror("nftnl_rule_set_data - userdata");
>> +			return;
>> +		}
>> +		nftnl_udata_buf_put(r->userdata, data, data_len);
>
> Think about this: From nft, we allocate the udata_buf, then we add th=
e
> attributes. Once we have the TLV area ready, we pass it as a pointer
> via nftnl_rule_set_data().
>
> Then, from libnftnl you allocate nftnl_udata_buf_alloc() again, but w=
e
> actually don't need this. The reason is that udata_buf is *only*
> needed to build the sequence of TLVs. Once we're done with it, we can
> just pass the memory blob area that contains this info.

I don't understand. With the modification to the patch [4/4 v6] you=20
made, there is still a data copy and it is passed in the same way. This=
=20
copy has moved from libnftnl to nft, but it still exists. Diff between=20
the original and modified version of "netlink_linearize_rule" function:

--- carlos/src/netlink_linearize.c
+++ pablo/src/netlink_linearize.c
@@ -1163,7 +1163,6 @@ void netlink_linearize_rule(struct netlink_ctx=20
*ctx, struct nftnl_rule *nlr,
  			    const struct rule *rule)
  {
  	struct netlink_linearize_ctx lctx;
-	struct nftnl_udata_buf *udata;
  	const struct stmt *stmt;

  	memset(&lctx, 0, sizeof(lctx));
@@ -1174,6 +1173,10 @@ void netlink_linearize_rule(struct netlink_ctx=20
*ctx, struct nftnl_rule *nlr,
  		netlink_gen_stmt(&lctx, stmt);

  	if (rule->comment) {
+		struct nftnl_udata_buf *udata;
+		uint32_t udlen;
+		void *ud;
+
  		udata =3D nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
  		if (!udata)
  			memory_allocation_error();
@@ -1182,9 +1185,11 @@ void netlink_linearize_rule(struct netlink_ctx=20
*ctx, struct nftnl_rule *nlr,
  					  rule->comment))
  			memory_allocation_error();

-		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
-				    nftnl_udata_buf_data(udata),
-				    nftnl_udata_buf_len(udata));
+		udlen =3D nftnl_udata_buf_len(udata);
+		ud =3D xmalloc(udlen);
+		memcpy(ud, nftnl_udata_buf_data(udata), udlen);
+
+		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA, ud, udlen);

  		nftnl_udata_buf_free(udata);
  	}

>
> For this reason, I'm entirely keeping back this patch.
>
> Good thing though is that we don't need it to get this working :-)
>

Now there are a couple of leaks because this patch added a couple of=20
neccessary 'frees':

@@ -75,6 +82,8 @@ void nftnl_rule_free(struct nftnl_rule *r)
  		xfree(r->table);
  	if (r->chain !=3D NULL)
  		xfree(r->chain);
+	if (r->flags & (1 << NFTNL_RULE_USERDATA))
+		nftnl_udata_buf_free(r->userdata);

  	xfree(r);
  }

and

@@ -162,8 +171,14 @@ void nftnl_rule_set_data(struct nftnl_rule *r,=20
uint16_t attr,
  		r->position =3D *((uint64_t *)data);
  		break;
  	case NFTNL_RULE_USERDATA:
-		r->user.data =3D (void *)data;
-		r->user.len =3D data_len;
+		if (r->flags & (1 << NFTNL_RULE_USERDATA))
+			nftnl_udata_buf_free(r->userdata);
+		r->userdata =3D nftnl_udata_buf_alloc(data_len);
+		if (!r->userdata) {
+			perror("nftnl_rule_set_data - userdata");
+			return;
+		}
+		nftnl_udata_buf_put(r->userdata, data, data_len);
  		break;
  	}

There are another 'frees' I think is better to change it for=20
'nftnl_udata_buf_free', although in practice it is the same.

If you agree, I'll send a modified version of patch [2/4 v6] without th=
e=20
xml and json chunks, but keeping "struct nftnl_udata_buf" in "struct=20
nftnl_rule":

  struct nftnl_rule {
  	struct list_head head;
@@ -38,10 +39,7 @@ struct nftnl_rule {
  	const char	*chain;
  	uint64_t	handle;
  	uint64_t	position;
-	struct {
-			void		*data;
-			uint32_t	len;
-	} user;
+	struct nftnl_udata_buf	*userdata;
  	struct {
  			uint32_t	flags;
  			uint32_t	proto;
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
