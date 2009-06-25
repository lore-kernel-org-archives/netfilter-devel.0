From: Richard Horton <arimus.uk@googlemail.com>
Subject: Re: iptables ERROR
Date: Thu, 25 Jun 2009 14:39:12 +0100
Message-ID: <56378e320906250639v18ad5fc0q96fef8a2539d59b0@mail.gmail.com>
References: <1245934611.4518.58.camel@ripper.synapse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39849 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZFYNjL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:39:11 -0400
Received: by bwz9 with SMTP id 9so1402447bwz.37
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2009 06:39:13 -0700 (PDT)
In-Reply-To: <1245934611.4518.58.camel@ripper.synapse.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/6/25 Ritesh Majumdar <r.majumdar@globallogic.com>:
>
> ipset -N a_ipset iphash
> iptables -N a
> iptables -N b
> iptables -A a -p udp -m set --set a_ipset dst -j b
>

Isn't it meant to be:-
iptables -A a -p udp -m set --set a_ipset,dst -j b

(note the insertion of a comma)
-- 
Richard Horton
Users are like a virus: Each causing a thousand tiny crises until the
host finally dies.
http://www.solstans.co.uk - Solstans Japanese Bobtails and Norwegian Forest Cats
http://www.pbase.com/arimus - My online photogallery
