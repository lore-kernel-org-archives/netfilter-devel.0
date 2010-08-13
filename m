From: Pete Kay <petedao@gmail.com>
Subject: event callback in netfilter-conntrack
Date: Fri, 13 Aug 2010 19:39:42 +0800
Message-ID: <AANLkTi=QAxRdeh1srRh8Xdz1qS2eJBzxcRfoNot4=GYd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38828 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0HMLjn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Aug 2010 07:39:43 -0400
Received: by yxg6 with SMTP id 6so890001yxg.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Aug 2010 04:39:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Does anyone know how to obtain the original sport value from struct
nf_conntrack *ct within the event callback handler?

Any help will be greatly appreciated.

P
