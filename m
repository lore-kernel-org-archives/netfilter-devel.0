Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761A1C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 10:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346873AbjKCKoy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 06:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346763AbjKCKox (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 06:44:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9013DD4E
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 03:44:46 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qyrfP-0000YD-RX; Fri, 03 Nov 2023 11:44:43 +0100
Date:   Fri, 3 Nov 2023 11:44:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUTPG3XsdIFu8RRb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSZWS7StJ9nSP6cK@calendula>
 <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
 <ZSbD9fPv2Ltx8Cx2@calendula>
 <ZTE8xaZfFJoQRhjY@calendula>
 <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
 <ZUOJNnKJRKwj379J@calendula>
 <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
 <ZUQTWSEXbw2paJ3v@calendula>
 <ZUTEfXMw2e5kMJ5A@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZrQl2pp4aMGNuQlU"
Content-Disposition: inline
In-Reply-To: <ZUTEfXMw2e5kMJ5A@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ZrQl2pp4aMGNuQlU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 03, 2023 at 10:59:25AM +0100, Phil Sutter wrote:
[...]
> One would have to change it to work based on *.y branches and the actual
> commits in there. I'll give it a quick try, shouldn't be too hard
> indeed.

Please kindly find attached a "stable branch fork" of
collect_backports.sh. I was too lazy to check its output for missing
commits, but the ones it returns seem entirely valid.

Cheers, Phil

--ZrQl2pp4aMGNuQlU
Content-Type: application/x-sh
Content-Disposition: attachment; filename="collect_stable_backports.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0A# name of remote with the stable branches=0AREMOTENAME=3D"or=
igin"=0A=0A# branch to fetch fixes from=0AMASTERBRANCH=3D"$REMOTENAME/maste=
r"=0A=0A# paths=0Acd $(dirname $0)=0Abackports=3D./backports=0A=0Abrlist() =
{ # ()=0A	git branch -r | sed -n 's, *\('$REMOTENAME'/[0-9.]\+y\)$,\1,p'=0A=
}=0A=0Acommit_in_branch() { # (branch, commithash)=0A	# does commit exist i=
n branch?=0A	git merge-base --is-ancestor $2 $1 && return 0=0A=0A	# was it =
backported already?=0A	local parent_tag=3D$(git describe --tags --long $bra=
nch | \=0A			   sed 's/\(.*)-[^-]\+-[^-]\+$/\1/')=0A	git log $parent_tag..$=
1 | grep -q "^ *commit $2 upstream.$" && return 0=0A=0A	# does commit exist=
 in backport list?=0A	local brbase=3D${1#$REMOTENAME/}=0A	grep -q "^$2$" $b=
ackports/$brbase && return 0=0A=0A	return 1=0A}=0A=0Adeclare -A fixes_info=
=0A=0A# the while-loop is run in a sub-shell, so=0A# have this helper print=
 the list of hashes to stdout=0A__commit_fixes() { # (commithash)=0A	git lo=
g -1 $1 | grep '^ *Fixes: ' | while read fxs fshash fdesc; do=0A		# Fix for=
 wrong formatting of Fixes: line in commit=0A		# 164a9ff401e58 ("tc: flower=
: Fix parsing ip address")=0A		[[ $fshash =3D=3D '("'* ]] && fshash=3D${fsh=
ash#(\"}=0A=0A		# Fix for wrong formatting of Fixes: line in commit=0A		# 3=
5893864c87bb ("gre6: fix copy/paste bugs in GREv6 attribute manipulation")=
=0A		[[ $fshash =3D=3D *'("'* ]] && fshash=3D${fshash%(\"*}=0A=0A		# Fix fo=
r wrong formatting of Fixes: line in commit=0A		# 8df708afd62e4 ("ipaddress=
: Fix and make consistent label match handling")=0A		[[ $fshash =3D=3D "com=
mit" ]] && fshash=3D${fdesc%% *}=0A=0A		echo -n "$(git log -1 --oneline --f=
ormat=3D"%H" $fshash) "=0A	done=0A}=0A=0Acommit_fixes() { # (commithash)=0A=
	if [[ -v fixes_info[$1] ]]; then=0A		echo ${fixes_info[$1]}=0A		return=0A	=
fi=0A=0A	fixes_info[$1]=3D$(__commit_fixes $1)=0A=0A	# print found commits=
=0A	echo ${fixes_info[$1]}=0A}=0A=0Ashould_backport() { # (branch/tag, comm=
ithash)=0A	local hash=0A=0A	# does fixing commit exist in branch already?=
=0A	commit_in_branch $1 $2 && return 1=0A=0A	# check what this commit fixes=
=0A	for hash in $(commit_fixes $2); do=0A		# does fixed commit exist in bra=
nch?=0A		commit_in_branch $1 $hash && return 0=0A	done=0A=0A	# none of the =
fixed commits exist in this branch=0A	return 1=0A}=0A=0Acommits_since_base_=
of() { # (tag)=0A	local mergebase=3D$(git merge-base $1 $MASTERBRANCH)=0A	g=
it log --format=3D"%H" --reverse ${mergebase}..$MASTERBRANCH=0A}=0A=0Amkdir=
 -p $backports=0A=0A[[ -n $1 ]] && branches=3D$1 || branches=3D$(brlist)=0A=
for branch in $branches; do=0A	brbase=3D${branch#$REMOTENAME/}=0A	echo -n "=
$brbase: "=0A	touch $backports/$brbase=0A	for hash in $(commits_since_base_=
of $branch); do=0A		#echo "checking commit $hash"=0A=0A		# does it fix anyt=
hing?=0A		git log -1 $hash | grep -q ' *Fixes: ' || continue=0A=0A		# does =
it apply to this branch?=0A		should_backport $branch $hash || continue=0A=
=0A		echo -n "."=0A		# add it to backport list=0A		echo $hash >>$backports/=
$brbase=0A	done=0A	echo ""=0Adone=0A
--ZrQl2pp4aMGNuQlU--
