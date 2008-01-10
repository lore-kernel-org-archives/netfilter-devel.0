From: "Gilad Benjamini" <gilad.benjamini@gmail.com>
Subject: conntrack & valgrind
Date: Wed, 9 Jan 2008 17:57:38 -0800
Message-ID: <d95317090801091757s5ba5bcbfnf066f011e3488761@mail.gmail.com>
References: <d95317090801080112v662f7fcdk36b582d14557896d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:33650 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYAJB5j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:57:39 -0500
Received: by wa-out-1112.google.com with SMTP id v27so761056wah.23
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jan 2008 17:57:39 -0800 (PST)
In-Reply-To: <d95317090801080112v662f7fcdk36b582d14557896d@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is conntrack supposed to be "valgrind clean" ?
I ran a few times "valgrind  --tool=memcheck --show-reachable=yes conntrack -L"
and I always get different "Invalid read of size " messages.

The messages always seem to appear before the first listed connection.
I tried to track this down in the code, and I suspect it has to do
with the NL message alignment in nfnl_step, but this is only a hunch.
