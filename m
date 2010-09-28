From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
Date: Tue, 28 Sep 2010 02:00:27 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009280156170.5607@obet.zrqbmnf.qr>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>  <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>  <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>  <1285606896.2815.36.camel@localhost.localdomain>  <1285612156.4935.16.camel@sifl>
 <1285615525.2815.76.camel@localhost.localdomain> <4CA11F36.2090705@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Paris <eparis@redhat.com>, Paul Moore <paul.moore@hp.com>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
	sds@tycho.nsa.gov, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4CA11F36.2090705@netfilter.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 2010-09-28 00:48, Pablo Neira Ayuso wrote:

>On 27/09/10 21:25, Eric Paris wrote:
>> I see it as having 3 options.  lets assume was have a packet with
>> selinux sid=121 and selinux context=packet_t.  We can
>> 
>> 1) secmark=121 secctx=packet_t
>> 	This continues to send secmark like we do and people might continue to
>> be baffled by the 121.
>> 
>> 2) secmark=1 secctx=packet_t
>> 	This sends a secmark field to userspace so if an application which
>> reads this exists (I doubt such an application actually exists in in the
>> real world) it will still get all of the information it got before but
>> noone will be baffled by what the number means.  1/0 is pretty obvious.
>
>In netlink, we can obsolete fields without breaking backward
>compatibility. Applications parsing the /proc entry may break, but they
>should use stable interfaces (like netlink) instead.

Which I take as a pro stance on not adding any more procfs fields.

>BTW, if we finally stop including CTA_SECMARK in netlink messages,
>please add a small comment on the right of the definition in
>nfnetlink_conntrack.h (something like /* obsolete */ or /* unused */).
>Thanks!

Mh, I prefer "obsolete". A lot of times in the kernel there is "unused" 
and it reads like, "if it's unused, why is is there?" (it /is/ used, 
though as a filler).
