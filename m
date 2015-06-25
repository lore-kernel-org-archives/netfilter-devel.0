From: pfeiffer.szilard@balabit.hu
Subject: expectation entry creation with conntrack
Date: Thu, 25 Jun 2015 12:22:09 +0200
Message-ID: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pfeiffer.szilard@balabit.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([195.56.155.161]:38977 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbbFYKWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2015 06:22:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here are two patches that fix the expectation entry creation with connt=
rack
tool. First patch is only a refactor with the purpose to make the secon=
d
patch smaller and easier to understand. The second one fixes the entry
creation by using the necessary conntrack stucture.

BR,
Szil=C3=A1rd Pfeiffer
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
