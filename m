From: "Gilad Benjamini" <gilad.benjamini@gmail.com>
Subject: Why does conntrack need pthread ?
Date: Fri, 11 Jan 2008 12:11:12 -0800
Message-ID: <d95317090801111211x4d9884f2wa6732ddf8c13d3be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:1638 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759264AbYAKULN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:11:13 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1947691wah.23
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jan 2008 12:11:12 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Why is conntrack compiled with pthread ?
A simple test of removing it from compilation succeeded.
Is it needed in non-standard configurations ?
