Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCF7CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 15:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbjJSPXY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 11:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345450AbjJSPXX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 11:23:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D23D121
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 08:23:20 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qtUrj-0003Wo-Oo; Thu, 19 Oct 2023 17:23:15 +0200
Date:   Thu, 19 Oct 2023 17:23:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
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
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qKpgBvytys5koGD2"
Content-Disposition: inline
In-Reply-To: <ZTE8xaZfFJoQRhjY@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--qKpgBvytys5koGD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

On Thu, Oct 19, 2023 at 04:27:17PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 11, 2023 at 05:49:09PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Oct 11, 2023 at 05:25:59PM +0200, Phil Sutter wrote:
> > > On Wed, Oct 11, 2023 at 10:01:15AM +0200, Pablo Neira Ayuso wrote:
> > > > For the record, I have pushed out this 1.0.6.y branch:
> > > > 
> > > > http://git.netfilter.org/nftables/log/?h=1.0.6.y
> > > 
> > > I have this shell script collecting potential backports based on Fixes:
> > > tags. It identified 34 additional backports for v1.0.6 tag (hashes are
> > > meaningless):
> > > 
> > > e5b4169ee25ab json: expose dynamic flag
> > 
> > These are local commit IDs? Would it be possible to list with upstream
> > commit IDs for easier review?
> > 
> > > 0a7e53f2e0913 parser_json: Default meter size to zero
> > > 522e207b0a836 parser_json: Catch nonsense ops in match statement
> > > 725b096b99e56 parser_json: Wrong check in json_parse_ct_timeout_policy()
> > > 91401c4115b51 parser_json: Fix synproxy object mss/wscale parsing
> > > 7aee3e7754b22 parser_json: Fix limit object burst value parsing
> > > 60504c1817c42 parser_json: Fix flowtable prio value parsing
> > > 3b2f35cee7e1c parser_json: Proper ct expectation attribute parsing
> > > d804aa93a5988 parser_json: Fix typo in json_parse_cmd_add_object()
> > > 7e4eb93535418 parser_json: Catch wrong "reset" payload
> > 
> > I can see json fixes, these should be good too.
> > 
> > > ed0c72352193e netlink: handle invalid etype in set_make_key()
> > > 733470961f792 datatype: initialize TYPE_CT_EVENTBIT slot in datatype array
> > > 6e674db5d2990 datatype: initialize TYPE_CT_LABEL slot in datatype array
> > > f8ccde9188013 datatype: fix leak and cleanup reference counting for struct datatype
> > > 4b46a3fa44813 include: drop "format" attribute from nft_gmp_print()
> > > 930756f09a750 evaluate: fix check for truncation in stmt_evaluate_log_prefix()
> > > 987ae8d4b20de tests: monitor: Fix for wrong ordering in expected JSON output
> > > ad6cfbace2d2d tests: monitor: Fix for wrong syntax in set-interval.t
> > > b83bd8b441e41 tests: monitor: Fix monitor JSON output for insert command
> > > 0f8798917093a evaluate: Drop dead code from expr_evaluate_mapping()
> > > 2f2320a434300 tests: shell: Stabilize sets/0043concatenated_ranges_0 test
> > > fa841d99b3795 tests: fix inet nat prio tests
> > > 5604dd5b1f365 cache: include set elements in "nft set list"
> > > 8d1f462e157bc evaluate: set NFT_SET_EVAL flag if dynamic set already exists
> > > d572772659392 tests: shell: Fix for unstable sets/0043concatenated_ranges_0
> > > 4e4f7fd8334aa xt: Fix translation error path
> > > ca2fbde1ceeeb evaluate: insert byte-order conversions for expressions between 9 and 15 bits
> > > c0e5aba1bc963 xt: Fix fallback printing for extensions matching keywords
> > > 62a416b9eac19 tests: shell: cover rule insertion by index
> > > 0e5ea5fae26a3 evaluate: print error on missing family in nat statement
> > > cf35149fd378a netlink_delinearize: Sanitize concat data element decoding
> > > 1fb4c25073ed6 mnl: dump_nf_hooks() leaks memory in error path
> > > 2f14b059afd88 meta: parse_iso_date() returns boolean
> > > 99d6c23b32160 netlink: Fix for potential NULL-pointer deref
> 
> Would you send me your script?

Kindly find attached my collect_backports.sh. I keep it in an unused
sub-directory (~/git/nftables/stable_tooling), but it's not necessary.
It creates $(dirname $0)/backports directory containing a list of
potential backports for each tag in the range defined by the variables
in the script's header.

Cheers, Phil

--qKpgBvytys5koGD2
Content-Type: application/x-sh
Content-Disposition: attachment; filename="collect_backports.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0A# tag numbers we're interested in=0AMAJOR_MIN=3D0=0AMAJOR_MA=
X=3D1=0AMIDOR_MIN=3D0=0AMIDOR_MAX=3D9=0AMINOR_MIN=3D0=0AMINOR_MAX=3D9=0A=0A=
# paths=0Acd $(dirname $0)=0Abackports=3D./backports=0A=0Ataglist() { # ()=
=0A	local maj min=0A=0A	for ((maj =3D $MAJOR_MIN; maj <=3D $MAJOR_MAX; maj+=
+)); do=0A		for ((mid =3D $MIDOR_MIN; mid <=3D $MIDOR_MAX; mid++)); do=0A		=
	for ((min =3D $MINOR_MIN; min <=3D $MINOR_MAX; min++)); do=0A				git tag -=
l | grep "v$maj\.$mid\.$min" | tail -n 1=0A			done=0A		done=0A	done=0A}=0A=
=0Acommit_in_tag() { # (tag, commithash)=0A	# does commit exist in tag?=0A	=
git merge-base --is-ancestor $2 $1 && return 0=0A=0A	# does commit exist in=
 backport list?=0A	grep -q "^$2$" $backports/$1 && return 0=0A=0A	return 1=
=0A}=0A=0Adeclare -A fixes_info=0A=0A# the while-loop is run in a sub-shell=
, so=0A# have this helper print the list of hashes to stdout=0A__commit_fix=
es() { # (commithash)=0A	git log -1 $1 | grep '^ *Fixes: ' | while read fxs=
 fshash fdesc; do=0A		# Fix for wrong formatting of Fixes: line in commit=
=0A		# 164a9ff401e58 ("tc: flower: Fix parsing ip address")=0A		[[ $fshash =
=3D=3D '("'* ]] && fshash=3D${fshash#(\"}=0A=0A		# Fix for wrong formatting=
 of Fixes: line in commit=0A		# 35893864c87bb ("gre6: fix copy/paste bugs i=
n GREv6 attribute manipulation")=0A		[[ $fshash =3D=3D *'("'* ]] && fshash=
=3D${fshash%(\"*}=0A=0A		# Fix for wrong formatting of Fixes: line in commi=
t=0A		# 8df708afd62e4 ("ipaddress: Fix and make consistent label match hand=
ling")=0A		[[ $fshash =3D=3D "commit" ]] && fshash=3D${fdesc%% *}=0A=0A		ec=
ho -n "$(git log -1 --oneline --format=3D"%H" $fshash) "=0A	done=0A}=0A=0Ac=
ommit_fixes() { # (commithash)=0A	if [[ -v fixes_info[$1] ]]; then=0A		echo=
 ${fixes_info[$1]}=0A		return=0A	fi=0A=0A	fixes_info[$1]=3D$(__commit_fixes=
 $1)=0A=0A	# print found commits=0A	echo ${fixes_info[$1]}=0A}=0A=0Ashould_=
backport() { # (tag, commithash)=0A	local hash=0A=0A	# does fixing commit e=
xist in tag already?=0A	commit_in_tag $1 $2 && return 1=0A=0A	# check what =
this commit fixes=0A	for hash in $(commit_fixes $2); do=0A		# does fixed co=
mmit exist in tag?=0A		commit_in_tag $1 $hash && return 0=0A	done=0A=0A	# n=
one of the fixed commits exist in this tag=0A	return 1=0A}=0A=0Acommits_sin=
ce_tag() { # (tag)=0A	local mergebase=3D$(git merge-base $1 origin/master)=
=0A	git log --format=3D"%H" --reverse ${mergebase}..origin/master=0A}=0A=0A=
mkdir -p $backports=0A=0A[[ -n $1 ]] && tags=3D$1 || tags=3D$(taglist)=0Afo=
r tag in $tags; do=0A	echo -n "$tag: "=0A	touch $backports/$tag=0A	for hash=
 in $(commits_since_tag $tag); do=0A		#echo "checking commit $hash"=0A=0A		=
# does it fix anything?=0A		git log -1 $hash | grep -q ' *Fixes: ' || conti=
nue=0A=0A		# does it apply to this tag?=0A		should_backport $tag $hash || c=
ontinue=0A=0A		echo -n "."=0A		# add it to backport list=0A		echo $hash >>$=
backports/$tag=0A	done=0A	echo ""=0Adone=0A
--qKpgBvytys5koGD2--
