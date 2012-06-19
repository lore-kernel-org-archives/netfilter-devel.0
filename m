From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Journey of a network packet through linux 2.6 network stack
Date: Tue, 19 Jun 2012 13:10:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206191306510.23782@frira.zrqbmnf.qr>
References: <hau7egzm.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kernelnewbies@kernelnewbies.org, netfilter-devel@vger.kernel.org
To: AFT <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46191 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2FSLKp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:10:45 -0400
In-Reply-To: <hau7egzm.fsf@s1.test.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-06-19 12:25, AFT wrote:
>
>A document with this heading can be found for 2.4 network stack. But i
>have not found any document regarding 2.6 network stack.
>
>When i was searching netfilter mailing list archive, i got the following
>post :
>
>http://lists.netfilter.org/pipermail/netfilter/2007-August/069583.html
>
>in this post author mentioned about a document named after this. but
>does not gave any link to that document.
>
>so i'm wondering if any similar document can be found?


http://en.wikipedia.org/wiki/Netfilter
http://en.wikipedia.org/wiki/iptables

(And to answer the other two questions of Karim Sattar: 2. the code 
between kernel and user interface are obviously different, 3. iptables 
is not a daemon.)
