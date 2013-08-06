From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: state match incompatibilty across versions
Date: Tue, 6 Aug 2013 16:35:47 -0400
Message-ID: <CA+0KVf21Vg80iemsQD4mY-KKO6AtM-_o1Bq0-v79uubJ=4iuAg@mail.gmail.com>
References: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:46038 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3HFUgJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:36:09 -0400
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com [209.85.212.53])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@dunimos.ljlane.net)
	by dunimos.ljlane.net (Postfix) with ESMTPSA id 6746B2665A
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Aug 2013 16:36:08 -0400 (EDT)
Received: by mail-vb0-f53.google.com with SMTP id i3so945940vbh.40
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Aug 2013 13:36:07 -0700 (PDT)
In-Reply-To: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It appears to be in the change of state to an alias in 1.4.16.
