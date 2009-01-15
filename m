From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Thu, 15 Jan 2009 16:51:59 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901151651410.17559@fbirervta.pbzchgretzou.qr>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr> <496AEEB0.3080905@trash.net> <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
 <496F40DC.2000605@trash.net> <496F42F0.7050305@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	"Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <496F42F0.7050305@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thursday 2009-01-15 15:06, Pablo Neira Ayuso wrote:
>Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> But the spartanic output of those proc files barely helps (especially
>>> in light of multiple revisions), so here is the patch I spoke about,
>>> refreshed and rebased, that solves the worries.
>> 
>> That seems a bit overkill. Text-based representation also doesn't seem
>> ideal, iptables already has this information and a cmdline user will
>> simply use "iptables ... -h" to get the supported option. For other
>> programs a binary representation would probably be easier to handle.
>
>Agreed. The text-based interface seems to me like yet-another-interface
>that users may (ab)use (like /proc/net/nf_conntrack, I have seen people
>polling from it to display information, this was OK in the early days).
>Following this basis, one may come and implement another text-based
>interface to display the rule-set in the kernel and so on.

But is there an equivalent user tool and interface at this time
to obtain the same information?
