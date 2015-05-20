From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH -stable] netfilter: nf_tables: fix error handling of rule
 replacement
Date: Wed, 20 May 2015 13:12:39 +0100
Message-ID: <20150520121239.GA1708@ares>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, May 16, 2015 at 08:50:45PM +0200, Pablo Neira Ayuso wrote:
> [ upstream commit 59900e0a019e7c2bdb7809a03ed5742d311b15b3 ]
>

Thank you, Pablo.

I've took a look at these 7 patches, and most of them seem to be
applicable to the 3.16 kernel as well.  I'm queuing the following set
for the next 3.16 release:

 59900e0a019e ("netfilter: nf_tables: fix error handling of rule replac=
ement")
 78146572b9cd ("netfilter: Zero the tuple in nfnl_cthelper_parse_tuple(=
)")
 9889840f5988 ("netfilter: nf_tables: check for overflow of rule dlen f=
ield")
 749177ccc74f ("netfilter: nft_compat: set IP6T_F_PROTO flag if protoco=
l is set")
 d6b6cb1d3e6f ("netfilter: nf_tables: allow to change chain policy with=
out hook if it exists")
 16c45eda9603 ("netfilter: nft_rbtree: fix locking")

So, from your initial set, I've dropped only 4017a7ee693d ("netfilter:
restore rule tracing via nfnetlink_log").

Cheers,
--
Lu=EDs
