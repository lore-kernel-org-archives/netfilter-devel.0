From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: connlimit patch
Date: 12 Sep 2003 16:24:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1063376667.14384.27.camel@henrik.marasystems.com>
References: <20030912123433.97028.qmail@web21602.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: neo neo <neo_1979m@yahoo.com>
In-Reply-To: <20030912123433.97028.qmail@web21602.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

fre 2003-09-12 klockan 14.34 skrev neo neo:
>        The connlimit patch by Gerd Knorr  uses the fuction
> ip_conntrack_find_get() defined in ipt_conntrack_core.c. But it seems 
> ip_conntrack_find_get is not getting exported - I get an 
>    "unrsolved symbol - ip_conntrack_find_get" error when I try to
> insmod the module ipt_connlimit ( I use redhat linux 8.0).

Hmm.. it is exported in my kernel.. what kernel are you using?

The export was added in 2.4.21 and is included in p-o-m as
submitted/02_2.4.20.patch

> Is there any other way to get the  ipt_conntrack_tuple_hash from the
> given tuple?

Probably not.

Regards
Henrik

-- 
Henrik Nordstrom <hno@marasystems.com>
MARA Systems AB
