From: Hiroshi KIHIRA <hiro@dump-Storage.net>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Mon, 12 Sep 2011 20:52:59 +0900
Message-ID: <4E6DF29B.3020901@dump-Storage.net>
References: <4E68C314.3070709@dump-Storage.net> <20110912092807.GB2194@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vs-saku1.dump-storage.net ([49.212.16.99]:36722 "EHLO
	VS-SAKU1.dump-Storage.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab1ILLxB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:53:01 -0400
In-Reply-To: <20110912092807.GB2194@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(11/09/12 18:28), Pablo Neira Ayuso wrote:
> I think people should call iptables-restore -T to test the rule-set
> before, at least the first time the have saved the rule-set, to make
> sure that they don't run into inconsistencies.
>
> Applying the rule-set partially for one table may also result in
> inconsistencies, so I still don't see what we gain from allowing this.

Yes, The inconsistencies from syntax error can be avoided by -t/--test
option.

But, if the iptables-restore used in a rule generation script and it
fails, inconsistencies will occur. So, I think that the iptables-restore
should avoid the inconsistencies even if the wrong rule-set was inputted
at the real run.

Also, I think that the iptables-restore needs rollback capability for the
situation of iptc_commit failure.
