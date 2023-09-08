Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF17EE8018
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbjIHO4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244240AbjIHO4R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:56:17 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A76C1FDF;
        Fri,  8 Sep 2023 07:56:11 -0700 (PDT)
Received: from [78.30.34.192] (port=50722 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qecty-00AV86-B5; Fri, 08 Sep 2023 16:56:09 +0200
Date:   Fri, 8 Sep 2023 16:56:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
Subject: Re: [nf-next RFC 2/2] selftests: netfilter: Test nf_tables audit
 logging
Message-ID: <ZPs2BX8vrmrrhCX2@calendula>
References: <20230908002229.1409-1-phil@nwl.cc>
 <20230908002229.1409-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230908002229.1409-3-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 08, 2023 at 02:22:29AM +0200, Phil Sutter wrote:
> Perform ruleset modifications and compare the NETFILTER_CFG type
> notifications emitted by auditd match expectations.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Calling auditd means enabling audit logging in kernel for the remaining
> uptime. So this test will slow down following ones or even cause
> spurious failures due to unexpected kernel log entries, timeouts, etc.
> 
> Is there a way to test this in a less intrusive way? Maybe fence this
> test so it does not run automatically (is it any good having it in
> kernel then)?

I think you could make a small libmnl program to listen to
NETLINK_AUDIT events and filter only the logs you need from there. We
already have a few programs like this in the selftest folder.

> ---
>  .../testing/selftests/netfilter/nft_audit.sh  | 75 +++++++++++++++++++
>  1 file changed, 75 insertions(+)
>  create mode 100755 tools/testing/selftests/netfilter/nft_audit.sh
> 
> diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
> new file mode 100755
> index 0000000000000..55c750720137f
> --- /dev/null
> +++ b/tools/testing/selftests/netfilter/nft_audit.sh
> @@ -0,0 +1,75 @@
> +#!/bin/bash
> +
> +SKIP_RC=4
> +RC=0
> +
> +nft --version >/dev/null 2>&1 || {
> +	echo "SKIP: missing nft tool"
> +	exit $SKIP_RC
> +}
> +
> +auditd --help >/dev/null 2>&1
> +[ $? -eq 2 ] || {
> +	echo "SKIP: missing auditd tool"
> +	exit $SKIP_RC
> +}
> +
> +tmpdir=$(mktemp -d)
> +audit_log="$tmpdir/audit.log"
> +cat >"$tmpdir/auditd.conf" <<EOF
> +write_logs = no
> +space_left = 75
> +EOF
> +auditd -f -c "$tmpdir" >"$audit_log" &
> +audit_pid=$!
> +trap 'kill $audit_pid; rm -rf $tmpdir' EXIT
> +sleep 1
> +
> +logread() {
> +	grep 'type=NETFILTER_CFG' "$audit_log" | \
> +		sed -e 's/\(type\|msg\|pid\)=[^ ]* //g' \
> +		    -e 's/\(table=[^:]*\):[0-9]*/\1/'
> +}
> +
> +do_test() { # (cmd, log)
> +	echo -n "testing for cmd: $1 ... "
> +	echo >"$audit_log"
> +	$1 >/dev/null || exit 1
> +	diff -q <(echo "$2") <(logread) >/dev/null && { echo "OK"; return; }
> +	echo "FAIL"
> +	diff -u <(echo "$2") <(logread)
> +	((RC++))
> +}
> +
> +nft flush ruleset
> +
> +for table in t1 t2; do
> +	echo "add table $table"
> +	for chain in c1 c2 c3; do
> +		echo "add chain $table $chain"
> +		echo "add rule $table $chain counter accept"
> +		echo "add rule $table $chain counter accept"
> +		echo "add rule $table $chain counter accept"
> +	done
> +done | nft -f - || exit 1
> +
> +do_test 'nft reset rules t1 c2' \
> +	'table=t1 family=2 entries=3 op=nft_reset_rule subj=kernel comm="nft"'
> +
> +do_test 'nft reset rules table t1' \
> +	'table=t1 family=2 entries=9 op=nft_reset_rule subj=kernel comm="nft"'
> +
> +do_test 'nft reset rules' \
> +	'table=t1 family=2 entries=9 op=nft_reset_rule subj=kernel comm="nft"
> +table=t2 family=2 entries=9 op=nft_reset_rule subj=kernel comm="nft"'
> +
> +for ((i = 0; i < 500; i++)); do
> +	echo "add rule t2 c3 counter accept comment \"rule $i\""
> +done | nft -f - || exit 1
> +
> +do_test 'nft reset rules t2 c3' \
> +	'table=t2 family=2 entries=189 op=nft_reset_rule subj=kernel comm="nft"
> +table=t2 family=2 entries=188 op=nft_reset_rule subj=kernel comm="nft"
> +table=t2 family=2 entries=126 op=nft_reset_rule subj=kernel comm="nft"'
> +
> +exit $RC
> -- 
> 2.41.0
> 
