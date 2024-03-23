Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54651A38F4
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711202210; cv=none; b=T1uLpMpCoXPaIjQ5ZmOMi3RGL+TP7iDJLWm0IXfGOs9XwEXHa2spVzYtot7YYYlglSgezLClS17e7Ks37pDOBf8S7ln1PzE0fViV/8liwsQ2jYw2+MCpAzz89EHPy3tCOh7ANDmAANX+DJ1d1Tdomd8uk+0YoBrXN/V/zNChSTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711202210; c=relaxed/simple;
	bh=22G/xKy+K11348K0JyKyiWMS0PSo1d6T8Furkro3QL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Le/+wSbLRrimew1ukeoTgkOKhtN0YxcebPFexxebaecT3hRfdEuwHc+DsQt7aYyiTyzw7MgR90xOj4GMZmi08zPvxjwzDoHuUp/wTxkzP3gnITigO3vdOtdx6dOe/KnMYj/kAOOBETE568NFyxmbqI9gDxqjMGKsOYxasvZE/Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qDmN0JVJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qDmN0JVJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xWGkfg8UBO62tPPd90Aj4mXaKcu6aKHHdd9T92VWXWY=; b=qDmN0JVJXf+7r1IetV9VU7vmWu
	0PAp4FV4SUtHVP7fq1evdtMFPHpjZfOjLhQC4CRgbaeTznozVmmfbecAIxrPEGUNygtyXErFe5v5O
	My/dr6LHLORv+w1a1MA/e7MKP2ZCT0YwqIMbPkbMiiXWvXXFlvRKl/QIhOAXhegp+uBJjkSe5m+GS
	nixQqAXz6mEEX/HbzKOkI4UE0m5SnLIlvgDQTLzwWnsGmjWF9mwloTZmZAz5t1tHztSIvO8jC5Zq9
	bH6RFQjhf/mxwxXDBEan+K20t+Y34fZW7RyU6M+rjooM3x0thsX1kZjlUnu61wE7ZLmAwMsKfrENV
	Sc0CzmXA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ro1rX-00000000696-3vAl;
	Sat, 23 Mar 2024 14:56:43 +0100
Date: Sat, 23 Mar 2024 14:56:43 +0100
From: Phil Sutter <phil@nwl.cc>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: Re: [PATCH iptables] libxtables: Fix xtables_ipaddr_to_numeric calls
 with xtables_ipmask_to_numeric
Message-ID: <Zf7fm6b4SC885EcU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Vitaly Chikunov <vt@altlinux.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
References: <20240323030641.988354-1-vt@altlinux.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SVs77uDWMlIyWWHJ"
Content-Disposition: inline
In-Reply-To: <20240323030641.988354-1-vt@altlinux.org>


--SVs77uDWMlIyWWHJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 23, 2024 at 06:06:41AM +0300, Vitaly Chikunov wrote:
> Frequently when addr/mask is printed xtables_ipaddr_to_numeric and
> xtables_ipmask_to_numeric are called together in one printf call but
> xtables_ipmask_to_numeric internally calls xtables_ipaddr_to_numeric
> which prints into the same static buffer causing buffer to be
> overwritten and addr/mask incorrectly printed in such call scenarios.
> 
> Make xtables_ipaddr_to_numeric to use two static buffers rotating their
> use. This simplistic approach will leave ABI not changed and cover all
> such use cases.

I don't quite like the cat'n'mouse game this opens, although it's
unlikely someone calls it a third time before copying the buffer.

What do you think about the attached solution?

Thanks, Phil

--SVs77uDWMlIyWWHJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="__xtables_ipaddr_to_numeric.diff"

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index f2fcc5c22fb61..54df1bc9336dd 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1511,12 +1511,19 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 	va_end(args);
 }
 
+static void
+__xtables_ipaddr_to_numeric(const struct in_addr *addrp, char *bufp)
+{
+	const unsigned char *bytep = (const void *)&addrp->s_addr;
+
+	sprintf(bufp, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
+}
+
 const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 {
 	static char buf[16];
-	const unsigned char *bytep = (const void *)&addrp->s_addr;
 
-	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
+	__xtables_ipaddr_to_numeric(addrp, buf);
 	return buf;
 }
 
@@ -1583,7 +1590,8 @@ const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
 	cidr = xtables_ipmask_to_cidr(mask);
 	if (cidr == (unsigned int)-1) {
 		/* mask was not a decent combination of 1's and 0's */
-		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
+		buf[0] = '/';
+		__xtables_ipaddr_to_numeric(mask, buf + 1);
 		return buf;
 	} else if (cidr == 32) {
 		/* we don't want to see "/32" */

--SVs77uDWMlIyWWHJ--
