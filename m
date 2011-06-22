From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/8] iptables: Coverity: DEADCODE
Date: Wed, 22 Jun 2011 15:49:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106221549150.14179@frira.zrqbmnf.qr>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com> <1307712362-17727-2-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50194 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab1FVNtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:49:24 -0400
In-Reply-To: <1307712362-17727-2-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-10 15:25, Jiri Popelka wrote:

>libiptc/libiptc.c:407: dead_error_condition: On this path, the condition "res > 0" cannot be false.
>libiptc/libiptc.c:396: at_least: After this line, the value of "res" is at least 1.
>libiptc/libiptc.c:393: equality_cond: Condition "res == 0" is evaluated as false.
>libiptc/libiptc.c:396: new_values: Noticing condition "res < 0".
>libiptc/libiptc.c:425: new_values: Noticing condition "res < 0".
>libiptc/libiptc.c:407: new_values: Noticing condition "res > 0".
>libiptc/libiptc.c:435: dead_error_line: Execution cannot reach this statement "return list_pos;".

Picked up by me.
