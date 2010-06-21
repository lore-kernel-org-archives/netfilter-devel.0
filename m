From: Mistick Levi <gmistick@gmail.com>
Subject: NF_Queue Copy made to userspace
Date: Mon, 21 Jun 2010 16:50:19 +0300
Message-ID: <AANLkTikhzTPI_cPrhmxbjlTTdKjEWi8cFHyF0C1GRzGp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39147 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab0FUNuX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:50:23 -0400
Received: by bwz7 with SMTP id 7so951779bwz.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2010 06:50:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

1. Does netfilter actually allocate memory in userspace and send a
*ptr to that memory in the socket to userspace ? ( Actually: How
netfilter copy the packet to userspace ? )
2. If i change the data of the packet in userspace, do i need to re
inject? or any change i make in userspace is saved before netfilter
continue with the packet?
3. Any main source of information regarding netfilter?

Kind regards
Yechiel Levi
