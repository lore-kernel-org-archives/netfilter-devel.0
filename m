From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] New target: SWITCH
Date: Thu, 5 Sep 2002 11:55:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905095531.GH1064@naboo.lincon.Uni-Koeln.DE>
References: <200209042334.g84NYEg03822@gonzalo.arana>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: garana@uolsinectis.com.ar
Content-Disposition: inline
In-Reply-To: <200209042334.g84NYEg03822@gonzalo.arana>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 04, 2002 at 08:34:14PM -0300, garana@uolsinectis.com.ar wrote:
> Hi,
> 
>   I am developing a new target which should redirect
> packets to a given host, no matter what routing table
> says.
>   This, with the aid of the random_patch (written by
> <fabrice@celestix.com>) should enable a Linux box
> to do a layer 3,4 switch work.
>   When I try to add a rule with this target:

First of all, thanks for your contribution.

However, if this ever is to be included into patch-o-matic or the
kernel, you _must_ adhere to /usr/src/linux/Documentation/CodingStyle.

This includes indentation and c++ (//) comments.

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
