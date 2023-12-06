Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D061A2
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:49:43 -0800 (PST)
Received: from [78.30.43.141] (port=34436 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rArLP-003RHH-Vs; Wed, 06 Dec 2023 13:49:42 +0100
Date: Wed, 6 Dec 2023 13:49:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Thomas Haller <thaller@redhat.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: flush ruleset with -U after feature
 probing
Message-ID: <ZXBt4iQxfPocp0V/@calendula>
References: <20231205154306.154220-1-pablo@netfilter.org>
 <20231205192929.GB8352@breakpoint.cc>
 <80b4cbbb54cf17a83ccbadaa3cd194790f87f67f.camel@redhat.com>
 <ZXBlvcV3jUfJCnMs@calendula>
 <20231206121828.GI8352@breakpoint.cc>
 <ZXBqEh4rV64PzhLH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cmTsmKUHBjRpelz/"
Content-Disposition: inline
In-Reply-To: <ZXBqEh4rV64PzhLH@calendula>
X-Spam-Score: -1.9 (-)


--cmTsmKUHBjRpelz/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Dec 06, 2023 at 01:33:25PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 06, 2023 at 01:18:28PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > The mode without unshare exists for historic reasons, as unshare was
> > > > added initially. At this point, what is the use of supporting or using
> > > > that?
> > > 
> > > This provides an easy way for me to test 'nft monitor'.
> > > 
> > > I can keep it out of tree if you prefer -U remains broken.
> > 
> > No no no, I was just asking if '-U' should still run the
> > feature probes without a netns, which is what its doing right
> > now.
> > 
> > Perhaps -U should just disable the unshare for the actual shell
> > tests, not for the feature probe scripts.
> 
> Ah, I understand. Fine with me.

Maybe this?

--cmTsmKUHBjRpelz/
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 86c8312683cc..55ebbe6d236d 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -497,6 +497,7 @@ detect_unshare() {
 		return 1
 	fi
 	NFT_TEST_UNSHARE_CMD="$1"
+	NFT_REAL_UNSHARE_CMD="$1"
 	return 0
 }
 
@@ -581,12 +582,12 @@ feature_probe()
 	local with_path="$NFT_TEST_BASEDIR/features/$1"
 
 	if [ -r "$with_path.nft" ] ; then
-		$NFT_TEST_UNSHARE_CMD "$NFT_REAL" --check -f "$with_path.nft" &>/dev/null
+		$NFT_REAL_UNSHARE_CMD "$NFT_REAL" --check -f "$with_path.nft" &>/dev/null
 		return $?
 	fi
 
 	if [ -x "$with_path.sh" ] ; then
-		NFT="$NFT_REAL" $NFT_TEST_UNSHARE_CMD "$with_path.sh" &>/dev/null
+		NFT="$NFT_REAL" $NFT_REAL_UNSHARE_CMD "$with_path.sh" &>/dev/null
 		return $?
 	fi
 
@@ -602,9 +603,6 @@ for feat in "${_HAVE_OPTS[@]}" ; do
 		val="$(bool_n "${!var}")"
 	fi
 	eval "export $var=$val"
-	if [ "$NFT_TEST_HAS_UNSHARED" != y ] ; then
-		$NFT flush ruleset
-	fi
 done
 
 if [ "$NFT_TEST_JOBS" -eq 0 ] ; then

--cmTsmKUHBjRpelz/--
