From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [Fwd: problems with ip6tables on sparc64 with 2.4.19]
Date: 25 Sep 2002 13:27:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032953238.849.74.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-aaqWflRFLYZaYJMMU1AV"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-aaqWflRFLYZaYJMMU1AV
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

this belongs here.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-aaqWflRFLYZaYJMMU1AV
Content-Disposition: inline
Content-Description: Forwarded message - problems with ip6tables on sparc64
	with 2.4.19
Content-Type: message/rfc822

Return-Path: <linux-net-owner@vger.kernel.org>
Delivered-To: gandalf@tux.rsn.bth.se
Received: from wlug.westbo.se (unknown [193.14.164.225]) by tux.rsn.bth.se
	(Postfix) with ESMTP id 5640336FC8 for <gandalf@tux.rsn.bth.se>; Wed, 25
	Sep 2002 13:17:20 +0200 (CEST)
Received: by wlug.westbo.se (Postfix) id E0312E919; Wed, 25 Sep 2002
	13:17:19 +0200 (CEST)
Delivered-To: gandalf@wlug.westbo.se
Received: by wlug.westbo.se (Postfix, from userid 99) id C340BE91D; Wed, 25
	Sep 2002 13:17:19 +0200 (CEST)
Received: from vger.kernel.org (vger.kernel.org [209.116.70.75]) by
	wlug.westbo.se (Postfix) with ESMTP id D7480E919 for
	<gandalf@wlug.westbo.se>; Wed, 25 Sep 2002 13:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand id
	<S261955AbSIYLLJ>; Wed, 25 Sep 2002 07:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id
	<S261957AbSIYLLJ>; Wed, 25 Sep 2002 07:11:09 -0400
Received: from squeaker.ratbox.org ([207.188.202.227]:40064 "EHLO
	squeaker.ratbox.org") by vger.kernel.org with ESMTP id <S261955AbSIYLLI>;
	Wed, 25 Sep 2002 07:11:08 -0400
Received: by squeaker.ratbox.org (Postfix, from userid 1000) id BB714301A6;
	Wed, 25 Sep 2002 07:16:21 -0400 (EDT)
Date: Wed, 25 Sep 2002 07:16:21 -0400 (EDT)
From: Aaron Sethman <androsyn@ratbox.org>
To: linux-net@vger.kernel.org
Subject: problems with ip6tables on sparc64 with 2.4.19
Message-ID: <Pine.LNX.4.44.0209250711320.1183-100000@squeaker.ratbox.org>
X-GPG-FINGRPRINT: 1024D/D4DE2553 0E60 59B5 60DA 2FD3 F6F5  27A3 6CD2 21AD
	D4DE 2553
X-GPG-PUBLIC_KEY: http://squeaker.ratbox.org/androsyn.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-net-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-net@vger.kernel.org
X-Spam-Status: No, hits=0.0 required=5.0 tests=none version=2.31
X-Spam-Level: 


Basically ip6tables pretty much doesn't work...I get the following error:

# ip6tables -L
ip6tables v1.2.7a: can't initialize ip6tables table `filter': Table does
not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.

After a bit of investigation I enabled the #define DEBUG_IP_FIREWALL_USER
in ip6_tables.c and got the following upon trying to load the
ip6tables_filter.o module:

translate_table: size 856
Bad offset 0000000140020074

Any clues or ideas on how to resolve this issue?

Regards,

Aaron

-
To unsubscribe from this list: send the line "unsubscribe linux-net" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-aaqWflRFLYZaYJMMU1AV--
