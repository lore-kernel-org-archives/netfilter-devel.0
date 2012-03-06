From: tingwei liu <tingw.liu@gmail.com>
Subject: NFQUEUE in bridge mode performance poor in the last kernels
Date: Tue, 6 Mar 2012 10:05:19 +0800
Message-ID: <CA+qZnSTG+_5y=6dGFqoJwRj0LxMvr2qtmyvykFjfnVgaYgbNPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39760 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758204Ab2CFCFU convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Mar 2012 21:05:20 -0500
Received: by obbuo6 with SMTP id uo6so4856698obb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Mar 2012 18:05:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the past few days, I have puzzled by NFQUEUE in bridge mode.
I have take some test with five kernels.
2.6.24.4
2.6.36.4
2.6.38
3.0.8
3.1.10

The result is : 2.6.24.4,2.6.26.4,2.6.38 have a goog performance;
3.0.8 and 3.1.10 have a poor performance.
Next is copy from suricata maillist(=C2=A0eric@regit.org=C2=A0)

I'm having a look at it. There has been some changes between the two
kernel versions (bringing more performances) but it seems there is some
side effects with bridge.
Thanks!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
