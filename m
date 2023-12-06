Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AF19A
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 04:16:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rAqph-0007oc-Az; Wed, 06 Dec 2023 13:16:53 +0100
Date: Wed, 6 Dec 2023 13:16:53 +0100
From: Florian Westphal <fw@strlen.de>
To: Thomas Haller <thaller@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH v2 nft] parser: tcpopt: fix tcp option parsing with NUM +
 length field
Message-ID: <20231206121653.GH8352@breakpoint.cc>
References: <20231205115610.19791-1-fw@strlen.de>
 <fcb3ef457002c89246c24a79290d25498ef7b0b0.camel@redhat.com>
 <20231206113836.GE8352@breakpoint.cc>
 <5aece71107a2716d9e6742cbc4e159c8c65a5ba0.camel@redhat.com>
 <20231206115906.GF8352@breakpoint.cc>
 <20231206120447.GG8352@breakpoint.cc>
 <9d11bf95bd1b07e15cd7160ab310794ea5d4b8b0.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d11bf95bd1b07e15cd7160ab310794ea5d4b8b0.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Thomas Haller <thaller@redhat.com> wrote:
> > Instead, feed the json-nft file to nft, then do a normal list-
> > ruleset,
> > then compare that vs. normal .nft file.
> 
> The .nft and .json-nft files are all fed back into `nft --check -f`. So
> that is happening too.

Not really, this checks that the parser eats the input.

> It will also comparing the raw files (after sanitize+prettify), which
> is closer to the original thing that is supposed to be tested. That is
> why it's done.

"metainfo": {
-        "json_schema_version": 1,
+        "version": "VERSION",
"release_name": "RELEASE_NAME",
-        "version": "VERSION"
+        "json_schema_version": 1
}
},

i.e. it fails validation because the on-record file has a different
layout/ordering than what is expected.

But if you feed it into nft, nft list ruleset will generate the expected
(non-json) output.

> What issues do you mean? I don't see any. Did you test/review the two
> patches?

The first one is applied.  The second one I applied locally.

But its still picky about the formatting.
