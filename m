Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1319180A80
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2025 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737653086; cv=none; b=Cep2Qq2nRrTuHypOW/ZKRQbZekMUWdfO98uHJInV7lLnK21CezD6OTQDhjXSaQL86Q6GCiZPkc7Oi22+2SixPWnoRAuAgtwtBmbMM1CdKFN/ELB69Mq+jtdiHYxOi0nUG19B/UTNiewmOLHmt8R/0SKcNbv2/OtNgL+A6U8CVLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737653086; c=relaxed/simple;
	bh=0vT3sQrd4J9K02FUu6mhCg3Dk2Q5olakP40o3JB/zqo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BowZxn/Up/4S+niQD7cPHSHa4IDc6kIGMBvhOTQ7Oy1XdIdWNvsbvw9snxiwuThynF0fu8tb29aEExjeTLi3jQS/18yF8i9oWxUdAXQgagFa8kL5uN4MT3qqrutXhhGWxWEWmN647gWWI1nlTZK+G/Ba/tFeM0bClsQi+MuWQv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mcPgtdAZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s46KcBTc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mcPgtdAZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s46KcBTc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0422B60292; Thu, 23 Jan 2025 18:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1737653082;
	bh=2G2yVocOnPh7X9L+HUMR+6k8pretgoLcO+mCxeMCX1w=;
	h=Date:From:To:Subject:From;
	b=mcPgtdAZELQzpBe+xkyjfEr+hT0k5oRAXWG2im9vUwTJdVRAF2Bn+NYXo7mQP3SKH
	 94Y627WmOdEwW/h4e79HwTx61i1cN/vMQHnm1CskwfH51LvkXm9VIC39llbzqx7MIV
	 snfHxHqha29D3Pj30JG7BDBY4ECcQaxjN9hvXGTwTc8/mx9vhE31JOiBnAk18pCQnQ
	 Gnfi3NmCk6ymxaEaljl5nitd6AK7sSlxHj+GlWt/EHeChvHA7a8yViIogvkEhETTu1
	 KrmTPhRXDhqdhg9IdRiZQrELay+3kik7VRY3b3/b4pLJhQs0cMy79m5bWilCgbrMrw
	 q5flaTxK243jw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8E4BA6028E
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2025 18:24:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1737653081;
	bh=2G2yVocOnPh7X9L+HUMR+6k8pretgoLcO+mCxeMCX1w=;
	h=Date:From:To:Subject:From;
	b=s46KcBTcLbWbFV2sz55sSIHDiqwQK69u7IH1ue8K5iC+S2LwfRciYww75GO2QaILp
	 9tS0i4k7Lc5VMX0MdmQbnQZS+yBHjqXFZM6kORBKtYkVj5DGuVTI6HzSsgZk9BGgPZ
	 7ds0+yj++xV4N+3dfOrupPlZ98jwEcZjjyC3gJC6qXEK0B5CmKw/ELMf1yTux2b9em
	 QA9shJmmtQ0HfIrD0gsvdJPXkdkltuo9wYFdrzY3z2XmIsVmduKHsU/o+TQospuYP0
	 YOlGIEZVZk8pdpdiAjqXqCEKBeKjCg1mJCv2T9NDEWDmUCOgZjkk0dbFDHXJ0Vj1Xo
	 h1nrDNzvi/P4A==
Date: Thu, 23 Jan 2025 18:24:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: nftables 1.0.6.y stable branch updates
Message-ID: <Z5J7Vh5OPORkmmXC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

I have updated the 1.0.6.y -stable branch:

https://git.netfilter.org/nftables/log/?h=1.0.6.y

This branch contains 254 selected commits out of the 753 commits
available between v1.0.6 and git HEAD.

I have run _current_ tests/shell and tests/py in git HEAD on this
branch, with the following results:

- tests/shell:

W: [DUMP FAIL]  223/440 testcases/sets/meter_0
W: [DUMP FAIL]  162/440 testcases/sets/0022type_selective_flush_0
W: [FAILED]     107/440 testcases/sets/0038meter_list_0

These tests fail because 1.0.6.y does not include the code to convert
meters to dynamic sets, it should be possible to make it later, this
requires no kernel update.

- tests/py. The following tests fail:

- numgen inc compatibility with ipv4_addr datatype: this is a
  userspace feature that is missing, this requires not kernel updates
  and it should be possible to backport it.
- icmpv6 match extension: there is an extension to improve matching
  capabilities of icmpv6 that is also not backports. This requires not
  kernel update, it should be possible to support it.
- last statement: that tells you when last match on rule/element has
  happened. This does not require a kernel update, it should be
  possible to support it.
- inner matching: this feature requires kernel >= 6.3.
- bitwise multiregister: this feature requires kernel >= 6.13.

Comments welcome.

Thanks.
