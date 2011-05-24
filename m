From: Oskar Berggren <oskar.berggren@gmail.com>
Subject: ipset and interfaces
Date: Tue, 24 May 2011 13:19:53 +0200
Message-ID: <BANLkTim0bcPRtN1PYSZz4TyKUHGasGhsBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49597 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1EXLUO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 07:20:14 -0400
Received: by bwz15 with SMTP id 15so5527274bwz.19
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 04:20:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Regarding ipsets.... how crazy would it be to add a set type
containing interface names?

And how crazy would it be to add a set type containing tuples of
ip-address and interface name?  (I.e. the set match would look for ip,
and match if a tuple with the proper interface is found)


/Oskar
