From: Kylie McClain <somasissounds@gmail.com>
Subject: [PATCH limnl] Fix test building on musl libc
Date: Thu, 21 Jul 2016 00:00:46 -0400
Message-ID: <20160721040047.30198-1-somasissounds@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33081 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbcGUEAv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 00:00:51 -0400
Received: by mail-qk0-f177.google.com with SMTP id p74so63729827qka.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 21:00:50 -0700 (PDT)
Received: from localhost.localdomain (cpe-65-184-25-62.carolina.res.rr.com. [65.184.25.62])
        by smtp.gmail.com with ESMTPSA id 55sm3290845qtm.36.2016.07.20.21.00.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Jul 2016 21:00:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apologies for the repeated email, I realized I forgot to sign-off on
the commit.
