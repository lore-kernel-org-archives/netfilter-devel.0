From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 17:43:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402291720220.27254-100000@filer.marasystems.com>
References: <20040229151700.GA26747@pcw.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20040229151700.GA26747@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 29 Feb 2004, Willy TARREAU wrote:

> Yesterday, I saw that you sent lots of pom-ng patches, but I didn't look
> at them because I didn't think that pom-ng was so much advanced. Today,
> I tried it for the first time, and looked back in the archives. I've found
> some of them again, but not all it seems.

The current ones interesting to users of pom-ng are:

[patch pomng] missing .ladd files etc 
[pomng patch] correctly break linked sources in ladd
[patch pomng] NETMAP c99 target initializer typo 

All three patches can be found in the netfilter archives or from
http://marasystems.com/download/netfilter/

With these pom-ng is at least up to the same level as pom for the set of 
patches we are using, and our only use of pom at this time is for the 
"submitted" category which still has a few patches of interest to us.

The convert2pomng.sh related patches are only of interest to developers
who need to convert their existing patches from pom to pomng format. This
script was used for making the large patch of missing .ladd files etc, and
to convert our local iptables patches not part of the standard pom tree
(mainly patches which has not been accepted into pom, plus some which is
not yet mature to be published)

Regards
Henrik
