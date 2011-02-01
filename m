From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 02/13] IP set core support
Date: Tue, 1 Feb 2011 22:22:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102012154130.24580@blackhole.kfki.hu>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <4D482817.7090407@trash.net>
 <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-142956158-1296595346=:24628"
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39350 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1BAVW2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:22:28 -0500
In-Reply-To: <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-142956158-1296595346=:24628
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Tue, 1 Feb 2011, Jozsef Kadlecsik wrote:

> On Tue, 1 Feb 2011, Patrick McHardy wrote:
> 
> > Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> > > +static int
> > > +call_ad(struct sk_buff *skb, struct ip_set *set,
> > > +	struct nlattr *tb[], enum ipset_adt adt,
> > > +	u32 flags, bool use_lineno)
> > > +{
> > > +	int ret, retried = 0;
> > > +	u32 lineno = 0;
> > > +	bool eexist = flags & IPSET_FLAG_EXIST;
> > > +
> > > +	do {
> > > +		write_lock_bh(&set->lock);
> > > +		ret = set->variant->uadt(set, tb, adt, &lineno, flags);
> > > +		write_unlock_bh(&set->lock);
> > > +	} while (ret == -EAGAIN &&
> > > +		 set->variant->resize &&
> > > +		 (ret = set->variant->resize(set, retried++)) == 0);
> > > +
> > > +	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
> > > +		return 0;
> > > +	if (lineno && use_lineno) {
> > > +		/* Error in restore/batch mode: send back lineno */
> > > +		struct nlmsghdr *nlh = nlmsg_hdr(skb);
> > > +		int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
> > > +		struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
> > > +		struct nlattr *cmdattr = (void *)nlh + min_len;
> > > +		u32 *errline;
> > > +
> > > +		nla_parse(cda, IPSET_ATTR_CMD_MAX,
> > > +			  cmdattr, nlh->nlmsg_len - min_len,
> > > +			  ip_set_adt_policy);
> > > +
> > > +		errline = nla_data(cda[IPSET_ATTR_LINENO]);
> > > +
> > > +		*errline = lineno;
> > 
> > This is still not correct. I didn't mean to remove the const attributes
> > (the message is still considered const by the higher layers, the netlink
> > functions just cast this away). You're modifying the received message,
> > I don't see how this can be useful to userspace.
> 
> I can't find where the message is considered const in netlink/nfnetlink.
> It seems to be freely writable via skb.
>  
> > I guess you're relying on that the original message is appended to a
> > nlmsgerr message. That doesn't seem right though, if you want to return
> > something to userspace, you should construct a new message.
> 
> The message we are processing here carried multiple commands (each having 
> an attribute with the line number of the given command) and one failed 
> from some reason. We have to notify the userspace which command, at what 
> line failed. For this reason the multi-command messages have got an 
> attribute, which can be filled out with the line number - that happens 
> here. The attribute is already there, the message is not enlarged, just
> the empty value is overwritten with the proper value.
> 
> The line number reporting works this way, tested in the testsuite too.
> 
> If I had to construct a completely new message and sent it, that'd be more 
> or less the duplication of netlink_ack. Additionally I had to suppress 
> netlink from sending an errmsg/ack too.

Hm, if I lie -EINTR to netlink, then I can construct and send the error 
message manually and keep NLM_F_ACK at the same time. What do you think?
Please have a look at the attached patch.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-142956158-1296595346=:24628
Content-Type: TEXT/x-diff; name=errline.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.1102012222260.24628@blackhole.kfki.hu>
Content-Description: errline.patch
Content-Disposition: attachment; filename=errline.patch

ZGlmZiAtLWdpdCBhL2tlcm5lbC9pcF9zZXRfY29yZS5jIGIva2VybmVsL2lw
X3NldF9jb3JlLmMNCmluZGV4IDE5MTU4YmYuLmNjNjdkOTIgMTAwNjQ0DQot
LS0gYS9rZXJuZWwvaXBfc2V0X2NvcmUuYw0KKysrIGIva2VybmVsL2lwX3Nl
dF9jb3JlLmMNCkBAIC0xMTAzLDcgKzExMDMsNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IG5sYV9wb2xpY3kgaXBfc2V0X2FkdF9wb2xpY3lbSVBTRVRfQVRU
Ul9DTURfTUFYICsgMV0gPSB7DQogfTsNCiANCiBzdGF0aWMgaW50DQotY2Fs
bF9hZChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgaXBfc2V0ICpzZXQs
DQorY2FsbF9hZChzdHJ1Y3Qgc29jayAqY3RubCwgc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IGlwX3NldCAqc2V0LA0KIAlzdHJ1Y3QgbmxhdHRyICp0
YltdLCBlbnVtIGlwc2V0X2FkdCBhZHQsDQogCXUzMiBmbGFncywgYm9vbCB1
c2VfbGluZW5vKQ0KIHsNCkBAIC0xMTIzLDEyICsxMTIzLDI1IEBAIGNhbGxf
YWQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGlwX3NldCAqc2V0LA0K
IAkJcmV0dXJuIDA7DQogCWlmIChsaW5lbm8gJiYgdXNlX2xpbmVubykgew0K
IAkJLyogRXJyb3IgaW4gcmVzdG9yZS9iYXRjaCBtb2RlOiBzZW5kIGJhY2sg
bGluZW5vICovDQotCQlzdHJ1Y3Qgbmxtc2doZHIgKm5saCA9IG5sbXNnX2hk
cihza2IpOw0KKwkJc3RydWN0IG5sbXNnaGRyICpyZXAsICpubGggPSBubG1z
Z19oZHIoc2tiKTsNCisJCXN0cnVjdCBza19idWZmICpza2IyOw0KKwkJc3Ry
dWN0IG5sbXNnZXJyICplcnJtc2c7DQorCQlzaXplX3QgcGF5bG9hZCA9IHNp
emVvZigqZXJybXNnKSArIG5sbXNnX2xlbihubGgpOw0KIAkJaW50IG1pbl9s
ZW4gPSBOTE1TR19TUEFDRShzaXplb2Yoc3RydWN0IG5mZ2VubXNnKSk7DQog
CQlzdHJ1Y3QgbmxhdHRyICpjZGFbSVBTRVRfQVRUUl9DTURfTUFYKzFdOw0K
LQkJc3RydWN0IG5sYXR0ciAqY21kYXR0ciA9ICh2b2lkICopbmxoICsgbWlu
X2xlbjsNCisJCXN0cnVjdCBubGF0dHIgKmNtZGF0dHI7DQogCQl1MzIgKmVy
cmxpbmU7DQogDQorCQlza2IyID0gbmxtc2dfbmV3KE5MTVNHX0RFRkFVTFRf
U0laRSwgR0ZQX0tFUk5FTCk7DQorCQlpZiAoc2tiMiA9PSBOVUxMKQ0KKwkJ
CXJldHVybiAtRU5PTUVNOw0KKwkJcmVwID0gX19ubG1zZ19wdXQoc2tiMiwg
TkVUTElOS19DQihza2IpLnBpZCwNCisJCQkJICBubGgtPm5sbXNnX3NlcSwg
TkxNU0dfRVJST1IsIHBheWxvYWQsIDApOw0KKwkJZXJybXNnID0gbmxtc2df
ZGF0YShyZXApOw0KKwkJZXJybXNnLT5lcnJvciA9IHJldDsNCisJCW1lbWNw
eSgmZXJybXNnLT5tc2csIG5saCwgbmxoLT5ubG1zZ19sZW4pOw0KKwkJY21k
YXR0ciA9ICh2b2lkICopJmVycm1zZy0+bXNnICsgbWluX2xlbjsNCisNCiAJ
CW5sYV9wYXJzZShjZGEsIElQU0VUX0FUVFJfQ01EX01BWCwNCiAJCQkgIGNt
ZGF0dHIsIG5saC0+bmxtc2dfbGVuIC0gbWluX2xlbiwNCiAJCQkgIGlwX3Nl
dF9hZHRfcG9saWN5KTsNCkBAIC0xMTM2LDYgKzExNDksOSBAQCBjYWxsX2Fk
KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBpcF9zZXQgKnNldCwNCiAJ
CWVycmxpbmUgPSBubGFfZGF0YShjZGFbSVBTRVRfQVRUUl9MSU5FTk9dKTsN
CiANCiAJCSplcnJsaW5lID0gbGluZW5vOw0KKw0KKwkJbmV0bGlua191bmlj
YXN0KGN0bmwsIHNrYjIsIE5FVExJTktfQ0Ioc2tiKS5waWQsIE1TR19ET05U
V0FJVCk7DQorCQlyZXR1cm4gLUVJTlRSOw0KIAl9DQogDQogCXJldHVybiBy
ZXQ7DQpAQCAtMTE3NCw3ICsxMTkwLDggQEAgaXBfc2V0X3VhZGQoc3RydWN0
IHNvY2sgKmN0bmwsIHN0cnVjdCBza19idWZmICpza2IsDQogCQkJCSAgICAg
YXR0cltJUFNFVF9BVFRSX0RBVEFdLA0KIAkJCQkgICAgIHNldC0+dHlwZS0+
YWR0X3BvbGljeSkpDQogCQkJcmV0dXJuIC1JUFNFVF9FUlJfUFJPVE9DT0w7
DQotCQlyZXQgPSBjYWxsX2FkKHNrYiwgc2V0LCB0YiwgSVBTRVRfQURELCBm
bGFncywgdXNlX2xpbmVubyk7DQorCQlyZXQgPSBjYWxsX2FkKGN0bmwsIHNr
Yiwgc2V0LCB0YiwgSVBTRVRfQURELCBmbGFncywNCisJCQkgICAgICB1c2Vf
bGluZW5vKTsNCiAJfSBlbHNlIHsNCiAJCWludCBubGFfcmVtOw0KIA0KQEAg
LTExODUsNyArMTIwMiw3IEBAIGlwX3NldF91YWRkKHN0cnVjdCBzb2NrICpj
dG5sLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAkJCSAgICBubGFfcGFyc2Vf
bmVzdGVkKHRiLCBJUFNFVF9BVFRSX0FEVF9NQVgsIG5sYSwNCiAJCQkJCSAg
ICAgc2V0LT50eXBlLT5hZHRfcG9saWN5KSkNCiAJCQkJcmV0dXJuIC1JUFNF
VF9FUlJfUFJPVE9DT0w7DQotCQkJcmV0ID0gY2FsbF9hZChza2IsIHNldCwg
dGIsIElQU0VUX0FERCwNCisJCQlyZXQgPSBjYWxsX2FkKGN0bmwsIHNrYiwg
c2V0LCB0YiwgSVBTRVRfQURELA0KIAkJCQkgICAgICBmbGFncywgdXNlX2xp
bmVubyk7DQogCQkJaWYgKHJldCA8IDApDQogCQkJCXJldHVybiByZXQ7DQpA
QCAtMTIyNyw3ICsxMjQ0LDggQEAgaXBfc2V0X3VkZWwoc3RydWN0IHNvY2sg
KmN0bmwsIHN0cnVjdCBza19idWZmICpza2IsDQogCQkJCSAgICAgYXR0cltJ
UFNFVF9BVFRSX0RBVEFdLA0KIAkJCQkgICAgIHNldC0+dHlwZS0+YWR0X3Bv
bGljeSkpDQogCQkJcmV0dXJuIC1JUFNFVF9FUlJfUFJPVE9DT0w7DQotCQly
ZXQgPSBjYWxsX2FkKHNrYiwgc2V0LCB0YiwgSVBTRVRfREVMLCBmbGFncywg
dXNlX2xpbmVubyk7DQorCQlyZXQgPSBjYWxsX2FkKGN0bmwsIHNrYiwgc2V0
LCB0YiwgSVBTRVRfREVMLCBmbGFncywNCisJCQkgICAgICB1c2VfbGluZW5v
KTsNCiAJfSBlbHNlIHsNCiAJCWludCBubGFfcmVtOw0KIA0KQEAgLTEyMzgs
NyArMTI1Niw3IEBAIGlwX3NldF91ZGVsKHN0cnVjdCBzb2NrICpjdG5sLCBz
dHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KIAkJCSAgICBubGFfcGFyc2VfbmVzdGVk
KHRiLCBJUFNFVF9BVFRSX0FEVF9NQVgsIG5sYSwNCiAJCQkJCSAgICAgc2V0
LT50eXBlLT5hZHRfcG9saWN5KSkNCiAJCQkJcmV0dXJuIC1JUFNFVF9FUlJf
UFJPVE9DT0w7DQotCQkJcmV0ID0gY2FsbF9hZChza2IsIHNldCwgdGIsIElQ
U0VUX0RFTCwNCisJCQlyZXQgPSBjYWxsX2FkKGN0bmwsIHNrYiwgc2V0LCB0
YiwgSVBTRVRfREVMLA0KIAkJCQkgICAgICBmbGFncywgdXNlX2xpbmVubyk7
DQogCQkJaWYgKHJldCA8IDApDQogCQkJCXJldHVybiByZXQ7DQo=

--110391808-142956158-1296595346=:24628--
