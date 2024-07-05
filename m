Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7AA156899
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 13:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720187255; cv=none; b=u8NRS77NrVjK7R3VZoSfkqISHARshDAlquqZ3P/QRI23MTJ3QZsRmlLvqWKyzRHRRBZBqC7j3FA0UXKdAuT8CbEclRUnQgzDUkOkin/Z80u0SUvE/cAhqxsSDMHtZQDTaUOn8j9puQV8LV4NA+4X4fVfHyox42F1esSHvRwT9CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720187255; c=relaxed/simple;
	bh=ZmCgPDxPiPTAT0MAUiImX4rm6+pYk9qtR37fM+4drRI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=s4O74gWJ9vEvifvaKT9gfQeW7YgVzXEZUSSO/TPsDrGUKfJQphXo9GESARqbayhNluX/iXYLvH2cWaSds/gHysg/QYT1eEKLRSOoHi2OvSjjs8NQC3W3fKdIqMTd0Z7cMv/raBXPcsTItB9PoKezHXS+eUDYpU3w9fgDBKTZsFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hdgYBraI; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hdgYBraI"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52e98087e32so1856456e87.2
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2024 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720187251; x=1720792051; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZmCgPDxPiPTAT0MAUiImX4rm6+pYk9qtR37fM+4drRI=;
        b=hdgYBraIkdbzfGQQ10Q2rttqitrT2cKldc8JTvKVl8kmGV+bocSlV97C5Bfu8RCHcQ
         kVxW1x7xyRmsrzwdHNtFDpNz8FxboXrU53qDRq6TasDFv1/Ze2JdB/4454jvUi4U+YYw
         5IjaCJSTpBt6wbU9AJuFmKEeroF8GKrEtFLju2zjPbZV59FC8y9WMFAlGBwYHtBnyWCo
         9ls9+GNoRg5VKy3SOsItArUF8J9usR541sMi3yAaargC6iY598l2IeDqhyF3t+5XxxkD
         32AdrgUJb+WR2zHgVYQkw/KgFB4baWNWiICPZsbjY6a16E4KuVa/9dHm5EkcY/kRk50W
         otiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720187251; x=1720792051;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZmCgPDxPiPTAT0MAUiImX4rm6+pYk9qtR37fM+4drRI=;
        b=XS6augnO/6KnmdiuvLgXldXkhYPe438BfdJTz4kvK+H5HEa4CidxugO7xTYzD2ZZTC
         7AKjnvZ4Dx2Z+1090xXwgMd7S+OV5oppQcM2g2nXAJG6MiW2RADuTZ9JYF1139AoJ2Vd
         wpXKYimpjxnrAAVnIoa/MZq2jtzXIDJ4m+bWqsgeHhaczNCV6ID3t5a8og77ExuppN2O
         zIgP5Lvz/ux0VnVj8xr1nr8GaN+oa2X4QCLN2OAdSBdxbFhhZk1cSkPzcUnqSuODnhS7
         H8mOwB8v82c7agQPKARNpX3nn9b+BYExxM0xGSM02xP6KrlAHVQnkIGTTZPbsP1iccpC
         nMgQ==
X-Gm-Message-State: AOJu0YyODjIDDeMaHLyfjzi3nQkFGEfFPDnS3sKeIdQcAZ9u6cAA1YIE
	U9Vj8LpfD/CA0QXWqZiSGyIRvwEbP135v4q2djuSucqVhRaoBT48CfgSk7qjjC0tAY5j0fyhNSm
	DEey0MdPIeHJLZ7X4NWj6/NaWNgjU32b9rjM=
X-Google-Smtp-Source: AGHT+IHiBl+kW3ZlAuaHB5yQ7iyw9GVpTKpkxELy1kvRd5bWwhDQ+fzskFNpfB+uGOpniLoIRPm07OYhuCZrxmyix7I=
X-Received: by 2002:ac2:5dcc:0:b0:52c:896f:930d with SMTP id
 2adb3069b0e04-52ea06e287bmr2930987e87.57.1720187251054; Fri, 05 Jul 2024
 06:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: josh lant <joshualant@googlemail.com>
Date: Fri, 5 Jul 2024 14:47:19 +0100
Message-ID: <CAMQRqNLQvfETbB6rpAP+QabsVGdwDmA0_7bxhK2jm0gcFQYm9g@mail.gmail.com>
Subject: iptables- accessing unallocated memory
To: netfilter-devel@vger.kernel.org, josh lant <joshualant@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi there,

I am currently trying to port iptables to ARM's new Morello
architecture; featuring hardware capabilities for memory protection.

One of the ways Morello affords protection is by enforcing bounds on
memory accesses at the hardware level. On Morello a segfault/bounds
fault will occur at runtime when an illegal memory access is made...

When running some of the iptables tests I am encountering some of
these faults. I have not investigated if they all occur in the same
spot yet, but at least 3 such occurrences in the same place are in
tests:
chain/0005base-delete_0
ebtables/0007-chain-policies_0
iptables/0002-verbose-output_0

Let us use ././testcases/iptables/0002-verbose-output_0 as an example
here, since I see different behaviour in two different versions of
iptables and libnftnl. (I had to update the package versions due to
another unrelated issue that I may ask about separately).

Bounds faults occur: iptables (1.8.10), libnftnl (master), libmnl
(1.0.5), kernel (6.4)
Bounds faults do not occur: iptables (1.8.7), libnftnl (1.2.1), libmnl
(1.0.5), kernel (6.4)

The segfault happens in compare_targets, when the memcmp checks the
data of the two xt_entry_target structs, when the rules are parsed and
checked using nft_rule_cmp:

https://git.netfilter.org/iptables/tree/iptables/nft-shared.c?h=v1.8.10#n414

The reason I see a fault in the updated iptables 1.8.10 and not 1.8.7
stems from the way the xt_entry_target structs are allocated in the
different versions, in both instances inside h->ops->rule_to_cs()
which calls nft_rule_to_iptables_command_state:

https://git.netfilter.org/iptables/tree/iptables/nft.c?h=v1.8.10#n2390

In 1.8.7, I see that 40B is allocated correctly, with enough space to
hold the data at the end of the xt_entry_target struct. The allocation
for this happens in the body of nft_rule_to_iptables_command_state
itself:

https://git.netfilter.org/iptables/tree/iptables/nft-shared.c?h=v1.8.7#n690

However, in 1.8.10, the allocation is performed while the expression
parsing happens, earlier within the nft_rule_to_iptables_command_state
function. In this instance nft_parse_immediate calls
nft_create_target. The wrapped __nft_create_target is then passed a
hard-coded 0B to the tgsize parameter. So in this instance no space is
ever allocated for the data at the end of xt_entry_target (hence the
segfault when trying to access this unallocated memory):

https://git.netfilter.org/iptables/tree/iptables/nft-ruleparse.c?h=v1.8.10#n99

If someone could give me some insight on how best to patch this and
pass an actual value to tgsize I would greatly appreciate it.
Particularly since nft_create_target is called in numerous places, and
I cannot find an obvious place where I might access the appropriate
data length to pass.

Many thanks,

Josh
