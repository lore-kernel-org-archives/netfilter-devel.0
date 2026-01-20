Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E244105F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 14:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919959; cv=none; b=SRq3dnl11HNqAZfc1+Zm4+12ElZHD8E42QOFJcp/ScFNPntVKNSplHQtKJJ5UtTIz957TqEpo1TkihDUEno6HOONcd59mqY/FCZRvm+7S+4m9SNT3tiWjv/jB4iO8QSfsHmgoxT6rYWIhOjQw+CEYovjXh1hHrWJujbnJDg0MlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919959; c=relaxed/simple;
	bh=C5xDsTZ34Ys/uf5tlLxOrSmND9Gs2IU+VP4B2XthPgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lmujNhBinb5Y/M+pUAJ0pQ1lY+U+izd2YQ1vP0lentQPUK4zB8H+bwR2bEM3QeqIFhYhpjW7zWZCUFNMsyEUjzhuuOtBBtTMDsQ3NJ/d1bTEwskFvEPhPVmb/04U14Lch86KxvgxWLB/UKs3QMITeqYc6MtPoz/1ed2aaiX4Abs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pajC+ObQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pajC+ObQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Pp1vo2pcbM0HUimoB6LUblNfyr7sACBdHQcUs7ur4xU=; b=pajC+ObQqRnlHt+/Y1VTP+V2Gt
	7ejLNa4CjeSV9n+tCo8cSYJLVe3ZjeeLNJCJpvfVrTBb9IKi1jk+Ia0xIPi3H2y5eUK7TIEvIJ1Ut
	UXgUiuKxKE/bROUYUAXlh/ywZ4nXU/UvU8UKfttppZ5AkClWHd09vF6igFNljkpsB0g9AINUTLs8x
	FffUqE+j0T86bwgefmA5jkjomaF5pfH6mUcb8zT6yiMjxwuvyoTMETESmNQ6lTplK+9l5HrLD8dMi
	1LA/z6qz87yoUrOm605EnTiPYcifBdOiI+MyYOIqOHRFLJ/eCtltFoohI8ytD1eEXhqNq7djwzL5Y
	PopFPdpQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viCt1-0000000089Z-0Cox;
	Tue, 20 Jan 2026 15:39:15 +0100
Date: Tue, 20 Jan 2026 15:39:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v5 2/3] tests: shell: add JSON test for all object types
Message-ID: <aW-Tk8BJd2jrPoIt@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20260119140813.536515-1-knecht.alexandre@gmail.com>
 <20260119140813.536515-3-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119140813.536515-3-knecht.alexandre@gmail.com>

On Mon, Jan 19, 2026 at 03:08:12PM +0100, Alexandre Knecht wrote:
[...]
> diff --git a/tests/shell/testcases/json/0007add_insert_delete_objects_0 b/tests/shell/testcases/json/0007add_insert_delete_objects_0
> new file mode 100755
> index 00000000..f701b062
> --- /dev/null
> +++ b/tests/shell/testcases/json/0007add_insert_delete_objects_0
> @@ -0,0 +1,145 @@
> +#!/bin/bash
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
> +
> +# Comprehensive test for JSON add/insert/delete/replace operations
> +# Tests that all object types work correctly with JSON commands
> +
> +set -e
> +
> +$NFT flush ruleset
> +
> +# ===== ADD operations =====
> +
> +echo "Test 1: Add table"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"table": {"family": "inet", "name": "test"}}}]}
> +EOF
> +
> +echo "Test 2: Add chain"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"chain": {"family": "inet", "table": "test", "name": "input_chain", "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}}]}
> +EOF
> +
> +echo "Test 3: Add rule"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "input_chain", "expr": [{"match": {"op": "==", "left": {"payload": {"protocol": "tcp", "field": "dport"}}, "right": 22}}, {"accept": null}]}}}]}
> +EOF
> +
> +echo "Test 4: Add set"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"set": {"family": "inet", "table": "test", "name": "test_set", "type": "ipv4_addr"}}}]}
> +EOF
> +
> +echo "Test 5: Add counter"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"counter": {"family": "inet", "table": "test", "name": "test_counter"}}}]}
> +EOF
> +
> +echo "Test 6: Add quota"
> +$NFT -j -f - << 'EOF'
> +{"nftables": [{"add": {"quota": {"family": "inet", "table": "test", "name": "test_quota", "bytes": 1000000}}}]}
> +EOF
> +
> +# Verify all objects were created
> +$NFT list ruleset > /dev/null || { echo "Failed to list ruleset after add operations"; exit 1; }

The command will succeed even if not a single one of the previous add
commands succeeded. To compare the resulting ruleset against
expectations, use a diff like so:

| EXPECT='table inet test {
| 	counter test_counter {
| 	}
| 	quota test_quota {
| 		bytes 1000000
| 	}
| 	set test_set {
| 		type ipv4_addr
| 	}
| 	chain input_chain {
| 		type filter hook input priority filter; policy accept;
| 
| 		tcp dport 22 accept
| 	}
| }'
| $DIFF -u <(echo "$EXPECT") <($NFT list ruleset) || { ... }

Otherwise looks good to me!

Thanks, Phil
