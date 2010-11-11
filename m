From: Kfir Lavi <lavi.kfir@gmail.com>
Subject: Verdict with ebtables?
Date: Thu, 11 Nov 2010 12:05:38 +0200
Message-ID: <AANLkTikxkvB2pagQswH1S8=sxA+OVfWrqO45FD6+hDQE@mail.gmail.com>
References: <AANLkTinCazaFKSXnfGe2e0nnfeRorV7AHcadQaxGvWg+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33980 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab0KKKFj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:05:39 -0500
Received: by wwb24 with SMTP id 24so15307wwb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Nov 2010 02:05:38 -0800 (PST)
In-Reply-To: <AANLkTinCazaFKSXnfGe2e0nnfeRorV7AHcadQaxGvWg+@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
It seems to me that its not possible to do a verdict in userspace of
ethernet packets, like it is done with nfqueue and iptables.
Why it is not implemented? Or, is there a way to do the same for
packets that are not arp or ip?

Thanks,
Kfir
