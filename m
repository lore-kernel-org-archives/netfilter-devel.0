From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Mon, 30 Nov 2015 13:31:43 +0100
Message-ID: <20151130123143.GA4233@salvia>
References: <20151127094958.GB15392@breakpoint.cc>
 <20151127095424.GF4263@macbook.localdomain>
 <20151127103428.GC15392@breakpoint.cc>
 <20151127104248.GD15392@breakpoint.cc>
 <20151127104923.GH4263@macbook.localdomain>
 <20151127105417.GE15392@breakpoint.cc>
 <20151128233201.GA3542@salvia>
 <20151129000929.GA15493@breakpoint.cc>
 <20151129220037.GA2301@salvia>
 <20151129223743.GA29878@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42133 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbbK3Mbr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Nov 2015 07:31:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CC5271324CF
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2015 13:31:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0675DA862
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2015 13:31:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 41E48DA86E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2015 13:31:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151129223743.GA29878@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 29, 2015 at 11:37:43PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Nov 29, 2015 at 01:09:29AM +0100, Florian Westphal wrote:
> > > Thanks for looking at this.  I'll take a closer look tomorrow,
> > > your patch works fine for ip version/hdrlength but seems it messes
> > > with endianess somewhere.
> > 
> > I forgot to update payload_shift_value() too, to skip the shift when
> > not needed, sorry, new patch attached.
> 
> Almost there. Again, with Patricks patch to fix VLAN header:
> 
> # src/nft --debug=netlink add rule bridge raw prerouting ether type vlan vlan type ip vlan id 4094 ip version 4 counter 
> bridge raw prerouting

OK, new try, the idea behind is to calculate this shift through:

        x = offset % BITS_PER_BYTE
        y = len % BITS_PER_BYTE

to get both offset and length at byte level.

Then calculate the shift based on this:

        shift = BITS_PER_BYTE - (x + y)

Does this look good to you?

--LQksG6bCIzRHxTLp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9840cd4..96f4dda 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -113,7 +113,8 @@ static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
 	mpz_t mask;
 
 	offset = expr->payload.offset % BITS_PER_BYTE;
-	shift = (expr->len % BITS_PER_BYTE) - offset;
+	len = expr->len % BITS_PER_BYTE;
+	shift = BITS_PER_BYTE - (offset + len);
 	masklen = expr->len + shift;
 
 	if (masklen > 128)
@@ -291,7 +292,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 static void payload_shift_value(const struct expr *left, struct expr *right)
 {
-	unsigned int shift, offset;
+	unsigned int shift, offset, len;
 
 	if (right->ops->type != EXPR_VALUE ||
 	    left->ops->type != EXPR_PAYLOAD)
@@ -300,7 +301,8 @@ static void payload_shift_value(const struct expr *left, struct expr *right)
 	if (left->payload.offset % BITS_PER_BYTE ||
 	    (left->payload.offset + left->len) % BITS_PER_BYTE) {
 		offset = left->payload.offset % BITS_PER_BYTE;
-		shift = (left->len % BITS_PER_BYTE) - offset;
+		len = left->len % BITS_PER_BYTE;
+		shift = BITS_PER_BYTE - (offset + len);
 		mpz_lshift_ui(right->value, shift);
 	}
 }

--LQksG6bCIzRHxTLp--
