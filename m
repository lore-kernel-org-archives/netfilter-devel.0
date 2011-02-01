From: Volkan YAZICI <volkan.yazici@gmail.com>
Subject: struct ipt_entry how to
Date: Wed, 02 Feb 2011 00:23:06 +0200
Message-ID: <871v3r2y45.fsf@alamut.ozu.edu.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55950 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab1BAWV2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:21:28 -0500
Received: by wwa36 with SMTP id 36so7573102wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Feb 2011 14:21:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I know that libiptc is not encouraged[1] for public use, but I'm trying
to figure out how rapidly I can interrupt the traffic on an interface
(if possible) with microsecond granularity; hence I want to issue direct
iptc_insert_entry() and iptc_delete_entry() calls without any strings
attached, e.g., start-up time, parsing, information gathering, table
initialization, etc. I'm reading the iptables sources and lost in the
mazes of generate_entry() stuff for creating a proper ipt_entry struct.
Does anybody have a sample code for that? Or can you point me to some
other relevant resource? Or, the worst, am I on my own on this matter?


Regards.

[1] http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015844.html
